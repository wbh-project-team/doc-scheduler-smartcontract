// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Ownable.sol';
import './Evaluations/Evaluation.sol';

contract DocScheduler is Ownable {
  //todo lege eine Struktur an die alle wichtigen Daten einer Arztpraxis enthält z.B. Name, öffnungszeiten, WalletAdresse des Arzt

  constructor() {}

  //todo lege Mapping vom Datentyp address auf die Struktur an damit alle erzeugten Arztpraxen gespeichert werden können

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
