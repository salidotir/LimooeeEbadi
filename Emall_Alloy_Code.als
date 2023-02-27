// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ******************* Signatures ***********************
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.

// ********************************************************
// ***************** Things To Know *******************
// 1- Int range in Alloy is from -8 to 7
// ********************************************************

// ********************************************************
// ************************ Users ************************
// ********************************************************

sig Id {}
sig Email {}
sig Password {}
sig PhoneNumber {}
sig FirstName {}
sig LastName {}
sig Date {}
sig Location {
	latitude: one Int,
	longitude: one Int
}{
	latitude >= -5 and latitude =< 5
	longitude >= -5 and longitude =< 5
}
sig Duration {}
sig BatteryCapacity {}
sig Name {}
sig Address {}
sig VIN {}		// VIN ~ vehicle identification number
sig SocketType {}
sig Text {}

sig EVDriver {
	email: one Email,
	password: one Password,
	firstName: one FirstName,
	lastName: one LastName,
	phoneNumber: one PhoneNumber,

	wallet: one Wallet,
	vehicles: set Vehicle,
	offers: set Offer,
	payments: set Payment	,
	ratings: set Rating,
	bookings: set Booking
}

sig Vehicle {
	vin: one VIN,
	Name: one Name
}

sig CPO {
	email: one Email,
	password: one Password,
	firstName: one FirstName,
	lastName: one LastName,
	chargingStations: set ChargingStation
}

sig DSO {
	companyName: one Name,
	currentPrice: one Int,
	Address: one Address,
	chargingStations: set ChargingStation
} {
	currentPrice > 0
}

// ********************************************************
// ****************** Other Entities *********************
// ********************************************************

sig Offer {
	offerName: one Name,
	discountPercent: one Int,
	fromDate: one Date,
	toDate: one Date
} {
	discountPercent > 0
}

sig Wallet {
	createdDate: one Date,
	credit: one Int
} {
	credit > 0
}

sig Booking {
	bookingDate: one Date,
	socket: one Socket
}

sig Payment {
	paymentDate: one Date,
	amount: one Int,
	offer: one Offer
} {
	amount > 0
}

sig ChargingSession {
	booking: one Booking,
	payment: one Payment,
	chargingDuration: one Duration
}

sig ChargingStation {
	location: one Location,
	sockets: set Socket,
	batteries: set Battery
}

sig Socket {
	powerSupplyAmount: one Int,
	type: one SocketType
} {
	powerSupplyAmount > 0
}

sig Battery {
	capacity: one BatteryCapacity,
	currentPrice: one Int
} {
	currentPrice > 0
}

sig Rating {
	score: one Int,
	reason: one Text,
	chargingStation: one ChargingStation
} {	// define score range from 0 to 5
	score >= 0
	score <= 5
}

// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ********************** Facts **************************
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.

// Links between User, EVDriver, CPO and their arttributes
// each email must be linked to only one EVDriver
fact EmailLinkedEVDriver{
	all e:Email |  one evd:EVDriver| e in evd.email
}

// each password must be linked to at least one EVDriver
fact PasswordLinkedEVDriver {
	all p:Password|  some evd:EVDriver | p in evd.password
}

// each first name must be linked to at least one EVDriver
fact FirstNameLinkedEVDriver {
	all fn:FirstName|  some evd:EVDriver | fn in evd.firstName
}

// each last name must be linked to at least one EVDriver
fact LastNameLinkedEVDriver {
	all ln:LastName|  some evd:EVDriver| ln in evd.lastName
}


// each phone number must be linked to only one EVDriver
fact PhoneNumberLinkedEVDriver {
	all pn:PhoneNumber|  one evd:EVDriver | pn in evd.phoneNumber
}

// each wallet must be linked to only one EVDriver
fact WalletLinkedEVDriver {
	all w: Wallet | one evd:EVDriver | w in evd.wallet
}

// each vehicle must have only one EVDriver as owner
fact VehicleLinkedEVDriver {
	all vehicle: Vehicle | one evd:EVDriver | vehicle in evd.vehicles
}

// each offer must be assciated to at least one EVDriver
fact OfferLinkedEVDriver {
	all o: Offer | some evd:EVDriver | o in evd.offers
}

// each must be linked to only one EVDriver
fact RatingLinkedEVDriver {
	all r: Rating | one evd: EVDriver | r in evd.ratings
}

// each rating must be linked to only one charging station
fact ChargingStationLinkedRating {
	all r: Rating | one cs: ChargingStation | cs in r.chargingStation 
}

// each booking must be linked to only one EVDriver
fact BookingLinkedEVDriver {
	all b: Booking | one evd: EVDriver | b in evd.bookings
}

// each payment must be linked to only one EVDriver
fact PaymentLinkedEVDriver {
	all p: Payment | one evd: EVDriver | p in evd.payments
}

// each vehicle must be linked to one VIN
fact VINLinkedVehicle {
	all v: VIN | one veh: Vehicle | v in veh.vin
}

// each email must be linked to only one CPO
fact EmailLinkedCPO{
	all e:Email |  one cpo:CPO | e in cpo.email
}

// each password must be linked to at least one CPO
fact PasswordLinkedCPO {
	all p:Password |  some cpo:CPO | p in cpo.password
}

// each first name must be linked to at least one CPO
fact FirstNameLinkedCPO {
	all fn:FirstName |  some cpo:CPO | fn in cpo.firstName
}

// each last name must be linked to at least one CPO
fact LastNameLinkedCPO {
	all ln:LastName |  some cpo:CPO | ln in cpo.lastName
}

// each charging station must be linked to at least one CPO
fact ChargingStationLinkedCPO {
	all cs:ChargingStation |  some cpo:CPO | cs in cpo.chargingStations
}

// each charging station must be linked to at least one DSO
fact ChargingStationLinkedDSO {
	all cs:ChargingStation |  some dso:DSO| cs in dso.chargingStations
}

// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.

// Socket & Charging Station & DSO & CPO links
// each location must refer to a diffrent place (latitude & longitude must be diffrent)
fact {
	all disj loc1, loc2: Location | 
	loc1.latitude = loc2.latitude => loc1.longitude != loc2.longitude
}

// each location must be linked to only one charging station
fact LocationLinkedChargingStation {
	all l: Location | one cs: ChargingStation | l in cs.location
}

// each socket must be linked to only one charging station
fact SocketLinkedChargingStation {
	all socket: Socket | one cs: ChargingStation | socket in cs.sockets
}

// each charging station must be linked to at least one socket
fact SocketLinkedChargingStation {
	all cs: ChargingStation| some s: Socket| s in cs.sockets
}

// each battery must be linked to only one socket
fact BatteryLinkedChargingStation {
	all battery: Battery| one cs: ChargingStation | battery in cs.batteries
}

// each charging station must be linked to only one CPO
fact ChargingStationLinkedCPO {
	all cs: ChargingStation | one cpo: CPO | cs in cpo.chargingStations
}

// each DSO must be linked to at least one charging station
fact ChargingStationLinkedDSO {
	all cs: ChargingStation | some dso: DSO | cs in dso.chargingStations
}

// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.

// Booking & Charging Process & Payment Links
// each booking must be linked to only one socket
fact BookingLinkedSocket {
	all b: Booking | one s: Socket | s in b.socket
}


// each booking must be linked to only one Date
fact BookingLinkedDate {
	all b: Booking | one d: Date | d in b.bookingDate
}

// each charging session must be linked to only one booking
// Charging session is created when charging process is started
fact BookingLinkedSession {
	all b: Booking | one session: ChargingSession | b in session.booking
}

// each charging session must be linked to only one payment
fact SessionLinkedPayment {
	all p: Payment | one session: ChargingSession | p in session.payment
}

// eahc payment must be linked to only one offer
fact paymentLinkedOffer {
	all p: Payment | one o: Offer | o in p.offer
}

// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ********************* Runing *************************
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.
// ~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.

//run {}
// Run the model
pred show {
	#EVDriver > 2
	#Vehicle > 2
	#CPO > 2
	#DSO > 1
	#ChargingStation > 2
	#Socket > 2
	#Offer = 2
}
run show for 10

