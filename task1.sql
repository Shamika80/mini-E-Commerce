app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://your_user:your_password@your_host:3306/your_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key' 

db.init_app(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login' # Set the login route


# Token-based authentication decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            token = request.headers['Authorization'].split(' ')[1]
        if not token:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = CustomerAccount.query.filter_by(id=data['id']).first()
        except:
            return jsonify({'message': 'Token is invalid'}), 401

        return f(current_user, *args, **kwargs)
    return decorated


@login_manager.user_loader
def load_user(user_id):
    return CustomerAccount.query.get(int(user_id))

# Customer Login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data or 'username' not in data or 'password' not in data:
        return jsonify({'message': 'Invalid credentials'}), 401

    user = CustomerAccount.query.filter_by(username=data['username']).first()
    if not user or not user.check_password(data['password']):
        return jsonify({'message': 'Invalid credentials'}), 401

    token = jwt.encode({'id': user.id}, app.config['SECRET_KEY'], algorithm="HS256")
    login_user(user) # This logs in the user using Flask-Login
    return jsonify({'token': token, 'message': 'Login successful'}), 200



# Customer Registration
@app.route('/register', methods=['POST'])
def register():
    form = CustomerAccountForm()
    if form.validate_on_submit():
        try:
            customer_data = request.get_json()
            new_customer = Customer(name=customer_data['name'], email=customer_data['email'],
                                   phone_number=customer_data['phone_number'])
            db.session.add(new_customer)
            db.session.flush()  

            new_account = CustomerAccount(
                customer_id=new_customer.id,
                username=form.username.data
            )
            new_account.set_password(form.password.data)
            db.session.add(new_account)
            db.session.commit()
            return jsonify({'message': 'Customer and account created', 'customer_id': new_customer.id}), 201
        except IntegrityError:
            db.session.rollback()
            return jsonify({'error': 'Username or email already exists'}), 400
        except Exception as e:
            db.session.rollback()
            return jsonify({'error': 'An error occurred', 'details': str(e)}), 500
    else:
        return jsonify(form.errors), 400

# Logout Route
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return jsonify({'message': 'Logged out successfully'}), 200
# .... (All other route as before with the validation, the error handling and the @token_required decorator before the @app.route(...) )


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)