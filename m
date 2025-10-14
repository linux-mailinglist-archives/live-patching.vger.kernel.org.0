Return-Path: <live-patching+bounces-1750-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36BF9BDB886
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 00:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D5C94E4457
	for <lists+live-patching@lfdr.de>; Tue, 14 Oct 2025 22:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAD22E2DD4;
	Tue, 14 Oct 2025 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="LY404ruG"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00206402.pphosted.com (mx0a-00206402.pphosted.com [148.163.148.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE112223702
	for <live-patching@vger.kernel.org>; Tue, 14 Oct 2025 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.148.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479371; cv=none; b=muMoEXEz7ON+UkwrvfFY94VEEOlObYMoj0XPptB/1fvXtumN4CKxr14Glm8NvrjdvJBv9FjA3LRzEU2fotP52xjc5T+l0oP/rYftRJeFLSMKicWRQdUZzVRFjEvvQpKdR17iJfTBos1hVhb8Yk0yPvq3pS8utqt01d4I40QIxcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479371; c=relaxed/simple;
	bh=Yo+bJUFBFiDlZlO9M9zdQYyih1rHkSkz2xG7yrfuZ80=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=N5d1RZWM6rWCQK2kKbHU/8Mffdy2r+98TL48PNAZSn11KVRVz8qVwkRCTiOgi3g+C+CrAyX5Qu/qbTs4p8TPOl3w/pLDCCD/D0CO8tAvAFwLo1FVwKeI9Tj8RuWBUbjHzq/Rt/SRHpp5/VaoZOX9bdki4IZPxGu8CjVf2Gi2kCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=LY404ruG; arc=none smtp.client-ip=148.163.148.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354650.ppops.net [127.0.0.1])
	by mx0a-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EK58s3000477;
	Tue, 14 Oct 2025 21:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=default; bh=Yo+bJUFBFiDlZlO9M9zdQYyi
	h1rHkSkz2xG7yrfuZ80=; b=LY404ruGNl4RXwiwUGK4av0LwZFDfOALRofjo4p8
	MwK6PICiMbfsf74rp4AzajuqIguzHbIYjur07MuUlMsHRZTq8MrOFf5s+wvGPkhi
	Unik2QBz2oarDf+4sHB9vqvJ+Uvy5KtWkL7mGBrQQhsU+GbxMiefTC24DQSK53CY
	ob9TGifxiX0itz4TKI0iChOrNVhW+jr3ZopzEITxOCk+Lg3OJ0a8qR89EWGiIaQf
	vk6sE30ugxl5umQCRVFAz9PigWWcG+vaK9FDxslPJTRib7ZYW6S55z/7D0b2IQIV
	dWsp6fe4wYgB3gkpF/bb3XP1LQDhqAAdCUh1BIw5WtUw0w==
Received: from mail.crowdstrike.com (74-209-223-77.static.ash01.latisys.net [74.209.223.77] (may be forged))
	by mx0a-00206402.pphosted.com (PPS) with ESMTPS id 49r3q8ywj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 21:37:51 +0000 (GMT)
Received: from 03WPEXCH010.crowdstrike.sys (10.80.52.162) by
 03WPEXCH010.crowdstrike.sys (10.80.52.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 14 Oct 2025 21:37:49 +0000
Received: from 03WPEXCH010.crowdstrike.sys ([fe80::7520:8ac3:8a3d:e06b]) by
 03WPEXCH010.crowdstrike.sys ([fe80::7520:8ac3:8a3d:e06b%6]) with mapi id
 15.02.2562.017; Tue, 14 Oct 2025 21:37:49 +0000
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
To: "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Question - Livepatch/Kprobe Coexistence on Ftrace-enabled Functions
 (Ubuntu kernel based on Linux  stable 5.15.30)
Thread-Topic: Question - Livepatch/Kprobe Coexistence on Ftrace-enabled
 Functions (Ubuntu kernel based on Linux  stable 5.15.30)
Thread-Index: AQHcPVBvRiosarywfE+UQ5SoUquMqQ==
Date: Tue, 14 Oct 2025 21:37:49 +0000
Message-ID: <c5058315a39d4615b333e485893345be@crowdstrike.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-disclaimer: USA
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Authority-Analysis: v=2.4 cv=H9PWAuYi c=1 sm=1 tr=0 ts=68eec2af cx=c_pps
 a=gZx6DIAxr9wtOoIAvRqG0Q==:117 a=gZx6DIAxr9wtOoIAvRqG0Q==:17
 a=xqWC_Br6kY4A:10 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=5mm09hDC4RfZxGnZvyAA:9
 a=QEXdDO2ut3YA:10 a=xLmh-q1SGZoA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDAxMiBTYWx0ZWRfX6HuSw4fvUdHZ
 WgBDBz1FuzdHkx9/nWOb8s0uTk2BXqXYt+nNxEKwJZnxB9OUo2EGwbURSBDPI1NmzWrS7ithDY8
 NJyn5tsbjeX17njcJ4toKz1nDRJcEZ/Q2SwPzGojNip+7xzgUPmrwW3700OXFnuz+FLYheH/T+1
 jvPdfm8AwUInBFRaBwXCFuI8ClJVAbtjBrCVNKf50bF8W2Z4mtjuMMU8BFz/AHuGyNrggh5QBHS
 TJ5Dh4WPC9I42BvV4fd9CBDuMdQ8S2dgx6+ddjI7Fm/pCFseQuOKk2rRL0QIwXy+fmrW+SOu91W
 hPCiADTOW4pzbQqE6qppUUYb4xCIjzPRjr8Y65Hf+SG3JIWUfkfrt8rgH7wRFuUsOdj2Yz1wsdk
 LHw8/nRiIK2lpns43NYMEF/UfM2hag==
X-Proofpoint-GUID: l-1TzxHWRaLGrMk99P95iI5ktoVgMKk8
X-Proofpoint-ORIG-GUID: l-1TzxHWRaLGrMk99P95iI5ktoVgMKk8
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11582
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510120012

RGVhciBVcHN0cmVhbSBMaXZlcGF0Y2ggIHRlYW0gYW5kIFVidW50dSBLZXJuZWwgdGVhbSAtIEkg
aW5jbHVkZWQgeW91IGJvdGggaW4gdGhpcyBzaW5jZSB0aGUgaXNzdWUgbGllcyBvbiB0aGUgYm91
bmRhcnkgYmV0d2VlbiBVYnVudHUga2VybmVsIGFuZCB1cHN0cmVhbS4gDQoNCkFjY29yZGluZyB0
byBvZmZpY2lhbCBrZXJuZWwgZG9jdW1lbnRhdGlvbiAgLSBodHRwczovL2RvY3Mua2VybmVsLm9y
Zy9saXZlcGF0Y2gvbGl2ZXBhdGNoLmh0bWwjbGl2ZXBhdGNoLCBzZWN0aW9uIDcsIExpbWl0YXRp
b25zIC0gDQoxIC0gS3JldHByb2JlcyB1c2luZyB0aGUgZnRyYWNlIGZyYW1ld29yayBjb25mbGlj
dCB3aXRoIHRoZSBwYXRjaGVkIGZ1bmN0aW9ucy4NCjIgLSBLcHJvYmVzIGluIHRoZSBvcmlnaW5h
bCBmdW5jdGlvbiBhcmUgaWdub3JlZCB3aGVuIHRoZSBjb2RlIGlzIHJlZGlyZWN0ZWQgdG8gdGhl
IG5ldyBpbXBsZW1lbnRhdGlvbi4NCg0KWWV0LCB3aGVuIHRlc3Rpbmcgb24gbXkgVWJ1bnR1IDUu
MTUuMC0xMDA1LjctYXdzIChiYXNlZCBvbiA1LjE1LjMwIHN0YWJsZSBrZXJuZWwpIG1hY2hpbmUs
IEkgaGF2ZSBubyBwcm9ibGVtIGFwcGx5aW5nIExpdmVwYXRjaCBhbmQgdGhlbiBzZXR0aW5nIGty
cG9iZXMgYW5kIGtyZXRwcm9iZXMgb24gYSBwYXRjaGVkIGZ1bmN0aW9uIHVzaW5nIGJwZnRyYWNl
IChvciBkaXJlY3RseSBieSBjb2RpbmcgYSBCUEYgcHJvZ3JhbSB3aXRoIGtwcm9iZS9rcmV0cHJv
YmUgYXR0YWNobWVudClhbmQgY2FuIGNvbmZpcm0gYm90aCBleGVjdXRlIHdpdGhvdXQgaXNzdWVz
LiBBbHNvIHRoZSBvcHBvc2l0ZSB3b3JrcyBmaW5lLCBydW5uaW5nIG15IGtycG9iZSBhbmQga3Jl
dHByb2JlIGhvb2tzIGRvZXNuJ3QgcHJldmVudCBmcm9tIGxpdmVwYXRjaCB0byBiZSBhcHBsaWVk
IHN1Y2Nlc3NmdWxseS4gDQoNCmZlbnRyeS9mZXhpdCBwcm9iZXMgZG8gZmFpbCBpbiBpbiBib3Ro
IGRpcmVjdGlvbnMgLSBidXQgdGhpcyBpcyBleHBlY3RlZCBhY2NvcmRpbmcgdG8gbXkgdW5kZXJz
dGFuZGluZyBhcyBjb2V4aXN0ZW5jZSBvZiBsaXZlcGF0Y2hpbmcgYW5kIGZ0cmFjZSBiYXNlZCBC
UEYgaG9va3MgYXJlIG11dHVhbGx5IGV4Y2x1c2l2ZSB1bnRpbCA2LjAgYmFzZWQga2VybmVscyAN
Cg0KbGliYnBmOiBwcm9nICdiZWdpbl9uZXdfZXhlY19mZW50cnknOiBmYWlsZWQgdG8gYXR0YWNo
OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQ0KbGliYnBmOiBwcm9nICdiZWdpbl9uZXdfZXhlY19m
ZW50cnknOiBmYWlsZWQgdG8gYXV0by1hdHRhY2g6IC0xNg0KDQoNClBsZWFzZSBoZWxwIG1lIHVu
ZGVyc3RhbmQgdGhpcyBjb250cmFkaWN0aW9uIGFib3V0IGtwcm9iZXMgLSBpcyB0aGlzIGJlY2F1
c2UgdGhlIEtQUk9CRVMgYXJlIEZUUkFDRSBiYXNlZCAgb3IgYW55IG90aGVyIHJlYXNvbiA/DQoN
Cg0KQmVsbG93IGEgZmV3IHByaW50cyB0byBwcm92ZSBteSBwb2ludCAtIHRoZSBrZXJuZWwgZnVu
Y3Rpb24gaSBhbSB1c2luZyB0byB0ZXN0IGlzIGJlZ2luX25ld19leGVjDQoNCnVidW50dUBpcC14
eHh4eDp+JCBzdWRvIGNhbm9uaWNhbC1saXZlcGF0Y2ggc3RhdHVzDQpsYXN0IGNoZWNrOiAxOSBt
aW51dGVzIGFnbw0Ka2VybmVsOiA1LjE1LjAtMTAwNS43LWF3cw0Kc2VydmVyIGNoZWNrLWluOiBz
dWNjZWVkZWQNCmtlcm5lbCBzdGF0ZTog4pyXIExpdmVwYXRjaCBjb3ZlcmFnZSBlbmRlZCAyMDIz
LTA1LTIwOyBwbGVhc2UgdXBncmFkZSB0aGUga2VybmVsIGFuZCByZWJvb3QNCnBhdGNoIHN0YXRl
OiDinJMgYWxsIGFwcGxpY2FibGUgbGl2ZXBhdGNoIG1vZHVsZXMgaW5zZXJ0ZWQNCnBhdGNoIHZl
cnNpb246IDk0LjENCnRpZXI6IHN0YWJsZQ0KbWFjaGluZSBpZDogeHh4eHgNCg0KdWJ1bnR1QGlw
LXh4eHh4eDp+JCBzdWRvIGNhdCAvcHJvYy9rYWxsc3ltcyB8IGdyZXAgYmVnaW5fbmV3X2V4ZWMN
CmZmZmZmZmZmOGFmN2JkYzAgVCBiZWdpbl9uZXdfZXhlYw0KZmZmZmZmZmY4YzMzNTY5NCByIF9f
a3N5bXRhYl9iZWdpbl9uZXdfZXhlYw0KZmZmZmZmZmY4YzM2OTgzMCByIF9fa3N0cnRhYm5zX2Jl
Z2luX25ld19leGVjDQpmZmZmZmZmZjhjMzZjZjNkIHIgX19rc3RydGFiX2JlZ2luX25ld19leGVj
DQpmZmZmZmZmZmMyOGMxNjUwIHQgYmVnaW5fbmV3X2V4ZWMJW2xrcF9VYnVudHVfNV8xNV8wXzEw
MDVfN19hd3NfOTRdDQpmZmZmZmZmZmMxYTlkMzg4IHQgYnBmX3Byb2dfMjExYTFkYzcxZGUxMTNh
NF9iZWdpbl9uZXdfZXhlY19rcHJvYmUJW2JwZl0NCmZmZmZmZmZmYzFhOWY1ODggdCBicGZfcHJv
Z181NTIyYmFjZmJiNzYyOGJkX2JlZ2luX25ld19leGVjX2tyZXRwcm9iZQlbYnBmXQ0KDQp1YnVu
dHVAaXAteHh4eHg6fiQgc3VkbyBjYXQgL3N5cy9rZXJuZWwvZGVidWcva3Byb2Jlcy9saXN0ICB8
IGdyZXAgYmVnaW5fbmV3X2V4ZWMNCmZmZmZmZmZmOGFmN2JkYzAgIHIgIGJlZ2luX25ld19leGVj
KzB4MCAgICBbRlRSQUNFXQ0KZmZmZmZmZmY4YWY3YmRjMCAgayAgYmVnaW5fbmV3X2V4ZWMrMHgw
ICAgIFtGVFJBQ0VdDQoNCg0Kcm9vdEBpcC14eHh4eDp+IyBlY2hvIDEwMjQwMCA+IC9zeXMva2Vy
bmVsL2RlYnVnL3RyYWNpbmcvYnVmZmVyX3NpemVfa2IgJiYgZWNobyAxID4gL3N5cy9rZXJuZWwv
ZGVidWcvdHJhY2luZy9ldmVudHMvYnBmX3RyYWNlL2VuYWJsZSAmJiBlY2hvIDEgPiAvc3lzL2tl
cm5lbC9kZWJ1Zy90cmFjaW5nL3RyYWNpbmdfb24gJiYgY2F0IA0KL3N5cy9rZXJuZWwvZGVidWcv
dHJhY2luZy90cmFjZV9waXBlDQogICAgICAgICAgICAgY2F0LTEwNDA2ICAgWzAwMF0gZC4uLjEg
NDMzMzQxLjAwMzAzNTogYnBmX3RyYWNlX3ByaW50azoga3Byb2JlOiBiZWdpbl9uZXdfZXhlYyBj
YWxsZWQgd2l0aCBicHJtPTAwMDAwMDAwNTMwNGEzNmUNCiAgICAgICAgICAgICBjYXQtMTA0MDYg
ICBbMDAwXSBkLi4uMSA0MzMzNDEuMDAzMTYzOiBicGZfdHJhY2VfcHJpbnRrOiBrcmV0cHJvYmU6
IGJlZ2luX25ld19leGVjIHJldHVybmVkIDANCg0K

