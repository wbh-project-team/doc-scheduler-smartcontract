// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Ownable.sol';
import './DateTimeContract.sol';

contract DocScheduler is Ownable {
  uint256 internal _counter;
  uint256 internal _reservationFee = 10000000000000;
  DateTimeContract _dateTime;

  struct Doctor {
    uint256 id;
    address owner;
    //todo move this data to ipfs
    string firstName;
    string lastName;
    string street;
    uint256 streetNumber;
    uint256 zipCode;
    string city;
    string phoneNumber;
    string freeText;
    uint256[] openingTime;
    uint256[] closingTime;
    uint256[] startLunchbreak;
    uint256[] stopLunchbreak;
    uint256[] specializations;
  }

  struct OfficeDay {
    uint256 openingTime;
    uint256 closingTime;
    uint256 startLunchbreak;
    uint256 stopLunchbreak;
  }

  Doctor[] internal _doctors;
  mapping(uint256 => Appointment[]) internal _appointments;
  mapping(uint256 => uint256) internal _appointmentCounter;
  mapping(uint256 => mapping(uint256 => uint256))
    internal _reservationFeeStorage;

  constructor(address dateTimeAddress) {
    _dateTime = DateTimeContract(dateTimeAddress);
  }

  function createDoctorsOffice(Doctor memory newDoctor) public {
    //todo add plausichecks
    _appointmentCounter[_counter] = 0;
    _doctors.push(
      Doctor(
        _counter++,
        msg.sender,
        newDoctor.firstName,
        newDoctor.lastName,
        newDoctor.street,
        newDoctor.streetNumber,
        newDoctor.zipCode,
        newDoctor.city,
        newDoctor.phoneNumber,
        newDoctor.freeText,
        newDoctor.openingTime,
        newDoctor.closingTime,
        newDoctor.startLunchbreak,
        newDoctor.stopLunchbreak,
        newDoctor.specializations
      )
    );
  }

  function reconfigureOffice(Doctor memory doctor) public {
    require(
      msg.sender == _doctors[doctor.id].owner,
      'Sorry, you have no permission to make changes'
    );

    _doctors[doctor.id].firstName = doctor.firstName;
    _doctors[doctor.id].lastName = doctor.lastName;
    _doctors[doctor.id].street = doctor.street;
    _doctors[doctor.id].streetNumber = doctor.streetNumber;
    _doctors[doctor.id].zipCode = doctor.zipCode;
    _doctors[doctor.id].city = doctor.city;
    _doctors[doctor.id].phoneNumber = doctor.phoneNumber;
    _doctors[doctor.id].freeText = doctor.freeText;
    _doctors[doctor.id].openingTime = doctor.openingTime;
    _doctors[doctor.id].closingTime = doctor.closingTime;
    _doctors[doctor.id].startLunchbreak = doctor.startLunchbreak;
    _doctors[doctor.id].stopLunchbreak = doctor.stopLunchbreak;
    _doctors[doctor.id].specializations = doctor.specializations;
  }

  function getDoctors() external view returns (Doctor[] memory) {
    return _doctors;
  }

  struct Appointment {
    uint256 id;
    uint256 startTime;
    uint256 duration;
    address patient;
    uint256 doctorsId;
    uint256 reservationFee;
  }

  //make seperate contract
  function createAppointment(Appointment calldata appointment)
    external
    payable
  {
    require(
      msg.value == _reservationFee,
      'msg.value not equal to reservation Fee'
    );

    _reservationFeeStorage[appointment.doctorsId][
      _appointmentCounter[appointment.doctorsId]
    ] = msg.value;
    _appointments[appointment.doctorsId].push(
      Appointment(
        _appointmentCounter[appointment.doctorsId]++,
        appointment.startTime,
        appointment.duration,
        appointment.patient,
        appointment.doctorsId,
        _reservationFee
      )
    );
  }

  function getAppointments(uint256 doctorId)
    external
    view
    returns (Appointment[] memory)
  {
    return _appointments[doctorId];
  }

  function getReservationFee() external view returns (uint256) {
    return _reservationFee;
  }

  function setReservationFee(uint256 newFee) external onlyOwner {
    _reservationFee = newFee;
  }

  function payoutAppointment(uint256 doctorId, uint256 appointmentId)
    external
  {}

  function getDay(uint256 startTime) public view returns (uint256) {
    return _dateTime.getDayOfWeek(startTime);
  }
}
