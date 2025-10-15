Return-Path: <live-patching+bounces-1755-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55AB7BE0E2C
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 23:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B63F3B405B
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 21:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1629C303C86;
	Wed, 15 Oct 2025 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="Tc9XTBi2"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00206402.pphosted.com (mx0b-00206402.pphosted.com [148.163.152.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56832549B
	for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.152.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565596; cv=none; b=rtZhMuMylWS/K6zSrl/QrUymWIkxB8MFT5Lc2YSHn0EWK20bTlSSwN0CqdEHu11EPCPjx2+G4jeADrv823VczINww6DIRDrSVCTs5tNNASLSwgWALyOlfS0Enzu0hOPFnWdUfI9XrUO4P9UwMurmzIFJMpZAdm1qxjLleCGZZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565596; c=relaxed/simple;
	bh=GW+JVOxpMqsDm7XFuPpNElPCHaNmQKCD4Ca0tPMao04=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=shYnrNOWWdoLkm/qc+hpaoxE1NGbOWsI1yi/mgbv5G6u775ysPrp+tORWtwbSqFXH/lP8gcjaxuufeUxwePl40+6/s7o1r/jEhEII0xH5EhDHpuA8++goILWJPMnjdRXY8Y4gzklcqtiaKdv0FAdR9/12lav3PXGiZaDjtfLu3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=Tc9XTBi2; arc=none smtp.client-ip=148.163.152.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354655.ppops.net [127.0.0.1])
	by mx0b-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FHIvmJ025549;
	Wed, 15 Oct 2025 21:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=GW+JVOxpMqsDm7XFuPpNElPCHaNmQKCD4Ca0tPMao04=; b=Tc9X
	TBi2qy1b/7Ep5xguTV3psihd2EBZWNQlRIAfftqXl8B/k+kE/MLmSa6To+2MMFx9
	G5D1HhkuxagcSJZQ48MaFm7weWKJD3V42xFDDwKqJW27DNYs1t6DdJGfX925+I1v
	pHSCA7YitfdCubm+Cd8XSIXw5zFB4g+PgrGFW2rixAVI37gjK13iUkz5LwVNoPiQ
	kEpKcPN+TnXrEyMlETOwScC7VJ+hc+PiMwYlaXZgBXCxk43PvpzWx849g0wL1i9I
	a5wQdjPMzlLLISkRvUtdin+iSjE5GWVlu7phQ73nIzWpFyN5tckY+7zhbLZ9ndc+
	+eakKDM/o65rdI3Hxg==
Received: from mail.crowdstrike.com (74-209-223-77.static.ash01.latisys.net [74.209.223.77] (may be forged))
	by mx0b-00206402.pphosted.com (PPS) with ESMTPS id 49r3ga37nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 21:11:43 +0000 (GMT)
Received: from [10.82.59.37] (10.100.11.122) by 03WPEXCH010.crowdstrike.sys
 (10.80.52.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 15 Oct
 2025 21:11:41 +0000
Message-ID: <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
Date: Wed, 15 Oct 2025 17:11:31 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Petr Mladek <pmladek@suse.com>
CC: "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <aO-LMaY-os44cEJP@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH006.crowdstrike.sys (10.100.11.70) To
 03WPEXCH010.crowdstrike.sys (10.80.52.162)
X-Disclaimer: USA
X-Proofpoint-GUID: tX7Pp9HauQPTAVZpifei1jX-7ceo7RvP
X-Proofpoint-ORIG-GUID: tX7Pp9HauQPTAVZpifei1jX-7ceo7RvP
X-Authority-Analysis: v=2.4 cv=AZy83nXG c=1 sm=1 tr=0 ts=68f00e0f cx=c_pps
 a=gZx6DIAxr9wtOoIAvRqG0Q==:117 a=gZx6DIAxr9wtOoIAvRqG0Q==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=IA0wh2spAAAA:8 a=JalwZFBbAAAA:8
 a=u66XdQ82RQCaSWfgcMwA:9 a=QEXdDO2ut3YA:10 a=xLmh-q1SGZoA:10
 a=jLBINTK38_0A:10 a=FTALrCdwyMEiDEKcuBsk:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDAxMiBTYWx0ZWRfX3SXE8rOLkTSt
 oUlnAzjGkHbd6HYFW6Qdnvp5XCtQm2wH6l4AYeR+JHr+1aYuZ18sOoyhFuM6RJF1YyHND/Itrtb
 kunIq4rfIZXLF6J30SmucxESjd0Vd39MvvvsC881CPGLMx3jIkswTzn1aK47zUp/mzy1XOKsYrJ
 dePNLJZWCpNu+zRxdY1i7bzMa6IEtrZ7AwSLGYZkOmH6xt7qaxWk9iQ4hY/C/SiEh3S/iZNncds
 kLEaIdXFSJbI8mGLkXROtGpLjMP6WvAy/rTIPXOY/39nc1qWf4KQsTubJcR/hZX4SKTWl4o2dDG
 F3fjGTmViLoNf1hwVg9r/HMQQjWtuCrsHhBFmO5uQKsZXPzYaVftEpeC1o/Aa0rEJJlDwKaiNFF
 yZm1a882Wg8WVe11JMMOR+M52K8XMw==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11583
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510120012

T24gMTAvMTUvMjUgMDc6NTMsIFBldHIgTWxhZGVrIHdyb3RlOg0KPiBPbiBUdWUgMjAyNS0x
MC0xNCAyMTozNzo0OSwgQW5kcmV5IEdyb2R6b3Zza3kgd3JvdGU6DQo+PiBEZWFyIFVwc3Ry
ZWFtIExpdmVwYXRjaCAgdGVhbSBhbmQgVWJ1bnR1IEtlcm5lbCB0ZWFtIC0gSSBpbmNsdWRl
ZCB5b3UgYm90aCBpbiB0aGlzIHNpbmNlIHRoZSBpc3N1ZSBsaWVzIG9uIHRoZSBib3VuZGFy
eSBiZXR3ZWVuIFVidW50dSBrZXJuZWwgYW5kIHVwc3RyZWFtLg0KPj4NCj4+IEFjY29yZGlu
ZyB0byBvZmZpY2lhbCBrZXJuZWwgZG9jdW1lbnRhdGlvbiAgLSBodHRwczovL3VybGRlZmVu
c2UuY29tL3YzL19faHR0cHM6Ly9kb2NzLmtlcm5lbC5vcmcvbGl2ZXBhdGNoL2xpdmVwYXRj
aC5odG1sKmxpdmVwYXRjaF9fO0l3ISFCbWR6UzNfbFY5SGRLRzghejNZNHZsRTdSY0NyaVQz
ejRIZzdjVmFvalpQTi15c1FUYmpESlZYeU9fTW9SUmxrS3N5bVVURFA0UEd2dlBhVjBURFZZ
aHppT1lNbTlXblVHdTVUZUZ4VXhRJCAsIHNlY3Rpb24gNywgTGltaXRhdGlvbnMgLQ0KPj4g
MSAtIEtyZXRwcm9iZXMgdXNpbmcgdGhlIGZ0cmFjZSBmcmFtZXdvcmsgY29uZmxpY3Qgd2l0
aCB0aGUgcGF0Y2hlZCBmdW5jdGlvbnMuDQo+PiAyIC0gS3Byb2JlcyBpbiB0aGUgb3JpZ2lu
YWwgZnVuY3Rpb24gYXJlIGlnbm9yZWQgd2hlbiB0aGUgY29kZSBpcyByZWRpcmVjdGVkIHRv
IHRoZSBuZXcgaW1wbGVtZW50YXRpb24uDQo+Pg0KPj4gWWV0LCB3aGVuIHRlc3Rpbmcgb24g
bXkgVWJ1bnR1IDUuMTUuMC0xMDA1LjctYXdzIChiYXNlZCBvbiA1LjE1LjMwIHN0YWJsZSBr
ZXJuZWwpIG1hY2hpbmUsIEkgaGF2ZSBubyBwcm9ibGVtIGFwcGx5aW5nIExpdmVwYXRjaCBh
bmQgdGhlbiBzZXR0aW5nIGtycG9iZXMgYW5kIGtyZXRwcm9iZXMgb24gYSBwYXRjaGVkIGZ1
bmN0aW9uIHVzaW5nIGJwZnRyYWNlIChvciBkaXJlY3RseSBieSBjb2RpbmcgYSBCUEYgcHJv
Z3JhbSB3aXRoIGtwcm9iZS9rcmV0cHJvYmUgYXR0YWNobWVudClhbmQgY2FuIGNvbmZpcm0g
Ym90aCBleGVjdXRlIHdpdGhvdXQgaXNzdWVzLiBBbHNvIHRoZSBvcHBvc2l0ZSB3b3JrcyBm
aW5lLCBydW5uaW5nIG15IGtycG9iZSBhbmQga3JldHByb2JlIGhvb2tzIGRvZXNuJ3QgcHJl
dmVudCBmcm9tIGxpdmVwYXRjaCB0byBiZSBhcHBsaWVkIHN1Y2Nlc3NmdWxseS4NCj4+DQo+
PiBmZW50cnkvZmV4aXQgcHJvYmVzIGRvIGZhaWwgaW4gaW4gYm90aCBkaXJlY3Rpb25zIC0g
YnV0IHRoaXMgaXMgZXhwZWN0ZWQgYWNjb3JkaW5nIHRvIG15IHVuZGVyc3RhbmRpbmcgYXMg
Y29leGlzdGVuY2Ugb2YgbGl2ZXBhdGNoaW5nIGFuZCBmdHJhY2UgYmFzZWQgQlBGIGhvb2tz
IGFyZSBtdXR1YWxseSBleGNsdXNpdmUgdW50aWwgNi4wIGJhc2VkIGtlcm5lbHMNCj4+DQo+
PiBsaWJicGY6IHByb2cgJ2JlZ2luX25ld19leGVjX2ZlbnRyeSc6IGZhaWxlZCB0byBhdHRh
Y2g6IERldmljZSBvciByZXNvdXJjZSBidXN5DQo+PiBsaWJicGY6IHByb2cgJ2JlZ2luX25l
d19leGVjX2ZlbnRyeSc6IGZhaWxlZCB0byBhdXRvLWF0dGFjaDogLTE2DQo+Pg0KPj4NCj4+
IFBsZWFzZSBoZWxwIG1lIHVuZGVyc3RhbmQgdGhpcyBjb250cmFkaWN0aW9uIGFib3V0IGtw
cm9iZXMgLSBpcyB0aGlzIGJlY2F1c2UgdGhlIEtQUk9CRVMgYXJlIEZUUkFDRSBiYXNlZCAg
b3IgYW55IG90aGVyIHJlYXNvbiA/DQo+IEhlaCwgaXQgc2VlbXMgdGhhdCB3ZSBoYXZlIGRp
c2N1c3NlZCB0aGlzIDEwIHllYXJzIGFnbyBhbmQgSSBhbHJlYWR5DQo+IGZvcmdvdCBtb3N0
IGRldGFpbHMuDQo+DQo+IFllcywgdGhlIGNvbmZsaWN0IGlzIGRldGVjdGVkIHdoZW4gS1BS
T0JFUyBhcmUgdXNpbmcgRlRSQUNFDQo+IGluZnJhc3RydWN0dXJlLiBCdXQgaXQgaGFwcGVu
cyBvbmx5IHdoZW4gdGhlIEtQUk9CRSBuZWVkcyB0byByZWRpcmVjdA0KPiB0aGUgZnVuY3Rp
b24gY2FsbCwgbmFtZWx5IHdoZW4gaXQgbmVlZHMgdG8gbW9kaWZ5IElQIGFkZHJlc3Mgd2hp
Y2ggd2lsbCBiZSB1c2VkDQo+IHdoZW4gYWxsIGF0dGFjaGVkIGZ0cmFjZSBjYWxsYmFja3Mg
YXJlIHByb2NlZWQuDQo+DQo+IEl0IGlzIHJlbGF0ZWQgdG8gdGhlIEZUUkFDRV9PUFNfRkxf
SVBNT0RJRlkgZmxhZy4NCg0KDQpJIHNlZSwgdGhhdCBleHBsYWlucyBteSBjYXNlIGFzIG15
IHByb2JlcyBhcmUgc2ltcGxlLCBwcmludCBvbmx5IHByb2JlcyANCnRoYXQgZGVmZW50bHkg
ZG9uJ3QgdGhhdCB0aGUgaXAgcG9pbnRlci4NCg0KQnV0IGkgc3RpbGwgZG9uJ3QgdW5kZXJz
dGFuZCBsaW1pdGF0aW9uIDIgYWJvdmUgZG9lc24ndCBzaG93IGl0c2VsZiAtIA0KaG93IG15
IGtwcm9iZXMgYW5kIGVzcGVjaWFsbHkga3JldHByb2JlcywgY29udGludWUgZXhlY3V0ZSBl
dmVuIGFmdGVyIA0KbGl2ZXBhdGNoIGFwcGxpZWQgdG8gdGhlIGZ1bmN0aW9uwqAgaSBhbSBh
dHRhY2hlZCB0byA/IFRoZSBjb2RlIGV4ZWN1dGlvbiANCmlzIHJlZGlyZWN0ZWQgdG8gYSBk
aWZmZXJlbnQgZnVuY3Rpb24gdGhlbiB0byB3aGljaCBpIGF0dGFjaGVkIG15IHByb2Jlcy4u
Lg0KDQpBbHNvIC0gY2FuIHlvdSBwbGVhc2UgY29uZmlybSB0aGF0IGFzIGZhciBhcyBpIGNo
ZWNrZWQsIHN0YXJ0aW5nIHdpdGggDQprZXJuZWwgNi4wIGZlbnRyeS9mZXhpdCBvbiB4ODYg
c2hvdWxkIG5vdCBoYXZlIGFueSBjb25mbGljdHMgd2l0aCANCmxpdmVwYXRjaCBwZXIgbWVy
Z2Ugb2YgdGhpcyBSRkMgLSANCmh0dHBzOi8vbGttbC5pdS5lZHUvaHlwZXJtYWlsL2xpbnV4
L2tlcm5lbC8yMjA3LjIvMDA4NTguaHRtbCA/DQoNClRoYW5rcywNCkFuZHJleQ0KDQo+DQo+
IE1vcmUgZGV0YWlscyBjYW4gYmUgZm91bmQgaW4gdGhlIGRpc2N1c3Npb24gYXQNCj4gaHR0
cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8y
MDE0MTEyMTEwMjUxNi4xMTg0NC4yNzgyOS5zdGdpdEBsb2NhbGhvc3QubG9jYWxkb21haW4v
VC8qcmU3NDY4NDZiNmIxNmM0OWE1NWM4OWI0YzYzYjc5OTVmZTU5NzIxMTFfXztJdyEhQm1k
elMzX2xWOUhkS0c4IXozWTR2bEU3UmNDcmlUM3o0SGc3Y1Zhb2paUE4teXNRVGJqREpWWHlP
X01vUlJsa0tzeW1VVERQNFBHdnZQYVYwVERWWWh6aU9ZTW05V25VR3U2cGp1SWdpZyQNCj4N
Cj4gSSBzZWVtcyB0aGF0IEkgbWFkZSBzb21lIGFuYWx5emUgd2hlbiBpdCB3b3JrZWQgYW5k
IGl0IGRpZCBub3Qgd29yaywNCj4gc2VlIGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19o
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAxNDExMjExMDI1MTYuMTE4NDQuMjc4Mjku
c3RnaXRAbG9jYWxob3N0LmxvY2FsZG9tYWluL1QvKm1mZmQ4YzhiZjQzMjViNDczZDg5ODc2
ZjI4MDVmNDJmMWFmN2M4MmQ3X187SXchIUJtZHpTM19sVjlIZEtHOCF6M1k0dmxFN1JjQ3Jp
VDN6NEhnN2NWYW9qWlBOLXlzUVRiakRKVlh5T19Nb1JSbGtLc3ltVVREUDRQR3Z2UGFWMFRE
VlloemlPWU1tOVduVUd1NXhiZW91bEEkDQo+IEJ1dCBJIGFtIG5vdCAxMDAlIHN1cmUgdGhh
dCBpdCB3YXMgY29ycmVjdC4gQWxzbyBpdCB3YXMgYmVmb3JlIHRoZQ0KPiBCUEYtYm9vbS4N
Cj4NCj4gQWxzbyB5b3UgbWlnaHQgbG9vayBhdCB0aGUgc2VsZnRlc3QgaW4gdGhlIHRvZGF5
cyBMaW51cycgdHJlZToNCj4NCj4gICAgKyB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9saXZl
cGF0Y2gvaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHA6Ly90ZXN0LWtwcm9iZS5z
aF9fOyEhQm1kelMzX2xWOUhkS0c4IXozWTR2bEU3UmNDcmlUM3o0SGc3Y1Zhb2paUE4teXNR
VGJqREpWWHlPX01vUlJsa0tzeW1VVERQNFBHdnZQYVYwVERWWWh6aU9ZTW05V25VR3U1UlhG
LUFuQSQNCj4gICAgKyB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9saXZlcGF0Y2gvdGVzdF9t
b2R1bGVzL3Rlc3Rfa2xwX2twcm9iZS5jDQo+ICAgICsgdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvbGl2ZXBhdGNoL3Rlc3RfbW9kdWxlcy90ZXN0X2tscF9saXZlcGF0Y2guYw0KPg0KPiBU
aGUgcGFyYWxsZWwgbG9hZCBmYWlscyB3aGVuIHRoZSBLcHJvYmUgaXMgdXNpbmcgYSBwb3N0
X2hhbmRsZXIuDQo+DQo+IFNpZ2gsIHdlIHNob3VsZCBmaXggdGhlIGxpdmVwYXRjaCBkb2N1
bWVudGF0aW9uLiBUaGUga3JldHByb2Jlcw0KPiBvYnZpb3VzbHkgd29yay4gcmVnaXN0ZXJf
a3JldHByb2JlKCkgZXZlbiBleHBsaWNpdGVseSBzZXRzOg0KPg0KPiAJcnAtPmtwLnBvc3Rf
aGFuZGxlciA9IE5VTEw7DQo+DQo+IEl0IHNlZW1zIHRoYXQgLnBvc3RfaGFuZGxlciBpcyBj
YWxsZWQgYWZ0ZXIgYWxsIGZ0cmFjZSBoYW5kbGVycy4NCj4gQW5kIGl0IHNldHMgSVAgYWZ0
ZXIgdGhlIE5PUHMsIHNlZSBrcHJvYmVfZnRyYWNlX2hhbmRsZXIoKS4NCj4gSSBhbSBub3Qg
c3VyZSBhYm91dCB0aGUgdXNlIGNhc2UuDQo+DQo+IEJlc3QgUmVnYXJkcywNCj4gUGV0cg0K
DQoNCg==

