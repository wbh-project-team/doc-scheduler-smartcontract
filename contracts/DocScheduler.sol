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
    string name;
    string street;
    uint256 zipCode;
    string city;
    string phoneNumber;
    string description;
    uint256[] openingTime;
    uint256[] closingTime;
    uint256[] lunchStart;
    uint256[] lunchEnd;
    string[] specializations;
    string[] categoryNames;
    uint256[] categoryDurations;
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
        newDoctor.name,
        newDoctor.street,
        newDoctor.zipCode,
        newDoctor.city,
        newDoctor.phoneNumber,
        newDoctor.description,
        newDoctor.openingTime,
        newDoctor.closingTime,
        newDoctor.lunchStart,
        newDoctor.lunchEnd,
        newDoctor.specializations,
        newDoctor.categoryNames,
        newDoctor.categoryDurations
      )
    );
  }

  function reconfigureOffice(Doctor memory doctor) public {
    require(
      msg.sender == _doctors[doctor.id].owner,
      'Sorry, you have no permission to make changes'
    );

    _doctors[doctor.id].firstName = doctor.firstName;
    _doctors[doctor.id].name = doctor.name;
    _doctors[doctor.id].street = doctor.street;
    _doctors[doctor.id].zipCode = doctor.zipCode;
    _doctors[doctor.id].city = doctor.city;
    _doctors[doctor.id].phoneNumber = doctor.phoneNumber;
    _doctors[doctor.id].description = doctor.description;
    _doctors[doctor.id].openingTime = doctor.openingTime;
    _doctors[doctor.id].closingTime = doctor.closingTime;
    _doctors[doctor.id].lunchStart = doctor.lunchStart;
    _doctors[doctor.id].lunchEnd = doctor.lunchEnd;
    _doctors[doctor.id].specializations = doctor.specializations;
    _doctors[doctor.id].categoryNames = doctor.categoryNames;
    _doctors[doctor.id].categoryDurations = doctor.categoryDurations;
  }

  function getDoctors() external view returns (Doctor[] memory) {
    return _doctors;
  }

  struct Appointment {
    uint256 id;
    uint256 startTime;
    string categoryName;
    uint256 duration;
    address patient;
    uint256 doctorsId;
    uint256 reservationFee;
  }

  //todo make seperate contract
  function createAppointment(
    Appointment calldata appointment
  ) external payable {
    require(
      msg.value == _reservationFee,
      'msg.value not equal to reservation Fee'
    );
    //todo check category name
    uint256 place = 0;
    for (
      uint256 i = 0;
      i < _doctors[appointment.doctorsId].categoryNames.length;
      i++
    ) {
      if (
        keccak256(
          abi.encodePacked(_doctors[appointment.doctorsId].categoryNames[i])
        ) == keccak256(abi.encodePacked(appointment.categoryName))
      ) {
        place = i;
        break;
      }
    }

    _reservationFeeStorage[appointment.doctorsId][
      _appointmentCounter[appointment.doctorsId]
    ] = msg.value;
    _appointments[appointment.doctorsId].push(
      Appointment(
        _appointmentCounter[appointment.doctorsId]++,
        appointment.startTime,
        appointment.categoryName,
        _doctors[appointment.doctorsId].categoryDurations[place],
        appointment.patient,
        appointment.doctorsId,
        _reservationFee
      )
    );
  }

  function getAppointments(
    uint256 doctorId
  ) external view returns (Appointment[] memory) {
    return _appointments[doctorId];
  }

  function getReservationFee() external view returns (uint256) {
    return _reservationFee;
  }

  function setReservationFee(uint256 newFee) external onlyOwner {
    _reservationFee = newFee;
  }

  function payoutAppointment(
    uint256 doctorId,
    uint256 appointmentId
  ) external {}

  function getDay(uint256 startTime) public view returns (uint256) {
    return _dateTime.getDayOfWeek(startTime);
  }
}
