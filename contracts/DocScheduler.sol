// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Ownable.sol';
import './Evaluations/Evaluation.sol';

//https://remix.ethereum.org

contract DocScheduler is Ownable {

  //todo lege eine Struktur an die alle wichtigen Daten einer Arztpraxis enthält z.B. Name, öffnungszeiten, WalletAdresse des Arzt
  struct Doctor {
      string first_name;
      string last_name;
      address wallet_address; // https://dev.singularitynet.io/docs/concepts/ethereum-address/
      OfficeDay[] office_hours;
      Description description; // evtl direkt in html Format oder besser verschiedene description variablen
      Specialization [] specialization;
  }

  struct OfficeDay {
    uint opening_time;
    uint closing_time;
    uint start_lunchbreak;
    uint stop_lunchbreak;
  }

  struct Description {
    string street;
    uint street_number;
    uint plz;
    string city;
    string phone_number;
    string free_text;
  }

  enum Specialization { HAUSARZT, ZAHNARZT, HNO-ARZT, ORTHOPAEDE, KARDEOLOGE, AUGENARZT}
  
  constructor() {}

  //todo lege Mapping vom Datentyp address auf die Struktur an damit alle erzeugten Arztpraxen gespeichert werden können
  mapping(address => Doctor) doctors;

  //todo erstelle createDoctorsOffice Methode
  //diese soll aus der Website aufgerufen werden und die Struktur übergeben bekommen
  //die Struktur soll in das Mapping unter der addrese des Arztes geschrieben werden

  //todo erstelle reconfigureOffice Methode
  //diese soll aus der Website aufgerufen werden und die Struktur übergeben bekommen
  //eintrag im Mapping soll mit der übergebenen Struktur überschrieben werden

  //todo erstelle createAppointment
  // checke ob praxis offen (require)
  // methode sollte payable sein, da Geld an Appointment durchgereicht werden muss
  // es soll ein neues Appointment(contract) erzeugt werden

  //
}
