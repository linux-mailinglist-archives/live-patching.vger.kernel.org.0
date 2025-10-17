Return-Path: <live-patching+bounces-1761-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 93177BEB683
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 21:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CD38934F30B
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 19:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBFA23EA82;
	Fri, 17 Oct 2025 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="hXJaNGXV"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00206402.pphosted.com (mx0b-00206402.pphosted.com [148.163.152.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E223D7E7
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 19:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.152.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760730518; cv=none; b=dsn6y7WFOQQp0/oHxtwnyd4OiR2+nkwlH1owEbDN4DplqfYEZUGIKnbatHe4y/6GyS4ZReU5mgz2shSndp1vLNjXdnY2eN8idfHnPnX9rGW8PKz0xl0tdLUSPnpt3QodKWuRW+0HojZK1VM1yFfIaEDunz79R+qDU7DRrBQvoGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760730518; c=relaxed/simple;
	bh=BYLndqxx28ko9vBAj4SvWTl2Xsmu8sjyx0JSEBhVsyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tyrN/Xl2CaiWmLzVc6aVnvH7jdn8jAqHYJhjY7uGpuD75/57nBK9yVMHLShv5WzUXpXuiH+zsTXzam9rJuaPNz5RVsHEAt+Zv/8cr/1aFR32CFL0AEjsDjVwG9JFQS3qY2SCDQ7YOUmx4Xv8M3Izn3BnB5aAzI8OJYzZsk1Kf+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=hXJaNGXV; arc=none smtp.client-ip=148.163.152.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354653.ppops.net [127.0.0.1])
	by mx0b-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HIHIgp032688;
	Fri, 17 Oct 2025 19:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=BYLndqxx28ko9vBAj4SvWTl2Xsmu8sjyx0JSEBhVsyE=; b=hXJa
	NGXVq/LqENs+CSSZx+g+A7SBUYaGJ/Zcuy9l+Nnq+wP7+TMUNANc1loiFBpnsNhv
	W8mivX35880JDpnxG7KiYJEoZQbzl8zByAWqPZvMsz/s6uufahenCjHDwfvUU/p3
	guDPf0+xPI289tmqCkX1dqK5LrcgWjibW/4Q5BcBWLypIkzf5p5wERSA845K90G5
	ryn1VO9DNp4Ypr7P3neuee+HEO8sjnWRfR0VRk56tmdID7O4iRSebYrn2n0dZC3e
	t4yAvkRprQOFwAL8njj+iDGdT+kmn3+Z6rCPus5C9nrmsCHZni/T4bhpw1kBLgoe
	cj32Bp2ldm2Sqtig+A==
Received: from mail.crowdstrike.com (74-209-223-77.static.ash01.latisys.net [74.209.223.77] (may be forged))
	by mx0b-00206402.pphosted.com (PPS) with ESMTPS id 49uqc112bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 19:48:19 +0000 (GMT)
Received: from [10.82.59.75] (10.100.11.122) by 03WPEXCH010.crowdstrike.sys
 (10.80.52.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 17 Oct
 2025 19:48:17 +0000
Message-ID: <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
Date: Fri, 17 Oct 2025 15:48:16 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Song Liu <song@kernel.org>
CC: Petr Mladek <pmladek@suse.com>,
        "kernel-team@lists.ubuntu.com"
	<kernel-team@lists.ubuntu.com>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz>
 <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz>
 <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com>
 <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH007.crowdstrike.sys (10.100.11.74) To
 03WPEXCH010.crowdstrike.sys (10.80.52.162)
X-Disclaimer: USA
X-Authority-Analysis: v=2.4 cv=LNlrgZW9 c=1 sm=1 tr=0 ts=68f29d83 cx=c_pps
 a=gZx6DIAxr9wtOoIAvRqG0Q==:117 a=gZx6DIAxr9wtOoIAvRqG0Q==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8
 a=2fFTO-RW4F9Dy2Zx2e0A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 3-y2-h3nhuK3nBNIXVmc1B_H7WhKG1ad
X-Proofpoint-GUID: 3-y2-h3nhuK3nBNIXVmc1B_H7WhKG1ad
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE3MDEwNSBTYWx0ZWRfXwUoWfzMnT0WT
 Qdd/xsS8go476M3uS6tYyBJEUCt9mXXs32szYe3rQtBVYzVgy145sM6+65t4yQ6xVJkjEq3S+wS
 NGOCDt4vxplUdR7qyOqE6/izY70LJz3uAmuwPrJ1qP7kquKpc12qhM50KYM5ZqePoBF9dEqToad
 P8mm7ukfVXtuKlXZyHBOjvJS7+kzPDPt8gv78nOCNGSQGWbMXYXxohVukyYCSpUQ4eKpScZnmdJ
 UwPQx2fcc/3KUZtRXL54K62/e3kwv6jdCWRwo2vYxF5OVvSyVnx90dNWz3XlebL/V2ah0Vms39/
 lebIXR1Hj11VDBbLZevJNH+y8dxcTrOTjywUXQKmZb2r5mgwigtjFoFUWbYR0Pd9Magpkmdlhci
 D38QQDbpVThDnHGRY8d2sIe9tJAtmg==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11585
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510170105

T24gMTAvMTcvMjUgMTU6MDcsIFNvbmcgTGl1IHdyb3RlOg0KPiBPbiBGcmksIE9jdCAxNywg
MjAyNSBhdCA5OjU44oCvQU0gU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+
PiBPbiBUaHUsIE9jdCAxNiwgMjAyNSBhdCAyOjU14oCvUE0gQW5kcmV5IEdyb2R6b3Zza3kN
Cj4+IDxhbmRyZXkuZ3JvZHpvdnNreUBjcm93ZHN0cmlrZS5jb20+IHdyb3RlOg0KPj4gWy4u
Ll0NCj4+PiBbQUddIC0gVHJ5aW5nIGZpcnN0IHRvIHBvaW50IGhpbSBhdCB0aGUgb3JpZ2lu
YWwgIGZ1bmN0aW9uIC0gYnV0IGhlDQo+Pj4gZmFpbHMgb24gdGhlIGZleGl0IEkgYXNzdW1l
ICAtIHdoaWNoIGlzIHN0cmFuZ2UsIEkgYXNzdW1lZCBmZXhpdA0KPj4+IChrcmV0ZnVuYykg
YW5kIGxpdmVwYXRjaCBjYW4gY29leGlzdCA/DQo+Pj4NCj4+PiB1YnVudHVAaXAtMTAtMTAt
MTE0LTIwNDp+JCBzdWRvIGJwZnRyYWNlIC1lDQo+Pj4gJ2ZlbnRyeTp2bWxpbnV4OmJlZ2lu
X25ld19leGVjIHsgQHN0YXJ0W3RpZF0gPSBuc2VjczsgcHJpbnRmKCItPiBFWEVDDQo+Pj4g
U1RBUlQgKGZlbnRyeSk6IFBJRCAlZCwgQ29tbSAlc1xuIiwgcGlkLCBjb21tKTsgfQ0KPj4+
IGZleGl0OnZtbGludXg6YmVnaW5fbmV3X2V4ZWMgeyAkbGF0ZW5jeSA9IG5zZWNzIC0gQHN0
YXJ0W3RpZF07DQo+Pj4gZGVsZXRlKEBzdGFydFt0aWRdKTsgcHJpbnRmKCI8LSBFWEVDIEVO
RCAoZmV4aXQpOiBQSUQgJWQsIENvbW0gJXMsDQo+Pj4gUmV0dmFsICVkLCBMYXRlbmN5ICVk
IHVzXG4iLCBwaWQsIGNvbW0sIHJldHZhbCwgJGxhdGVuY3kgLyAxMDAwKTsgfScNCj4+PiBB
dHRhY2hpbmcgMiBwcm9iZXMuLi4NCj4+PiBFUlJPUjogRXJyb3IgYXR0YWNoaW5nIHByb2Jl
OiBrcmV0ZnVuYzp2bWxpbnV4OmJlZ2luX25ld19leGVjDQo+Pj4NCj4+PiBbQUddIC0gVHJ5
aW5nIHRvIHNraXAgdGhlIGZleGl0IGFuZCBvbmx5IGRvIGZlbnRyeSAtIGhlIHN0aWxsIHJl
amVjdHMNCj4+PiB1YnVudHVAaXAtMTAtMTAtMTE0LTIwNDp+JCBzdWRvIGJwZnRyYWNlIC12
dnYgLWUNCj4+PiAnZmVudHJ5OnZtbGludXg6YmVnaW5fbmV3X2V4ZWMgeyBAc3RhcnRbdGlk
XSA9IG5zZWNzOyBwcmludGYoIi0+IEVYRUMNCj4+PiBTVEFSVCAoZmVudHJ5KTogUElEICVk
LCBDb21tICVzXG4iLCBwaWQsIGNvbW0pOyB9Jw0KPj4+IHN1ZG86IHVuYWJsZSB0byByZXNv
bHZlIGhvc3QgaXAtMTAtMTAtMTE0LTIwNDogVGVtcG9yYXJ5IGZhaWx1cmUgaW4gbmFtZQ0K
Pj4+IHJlc29sdXRpb24NCj4+PiBJTkZPOiBub2RlIGNvdW50OiAxMg0KPj4+IEF0dGFjaGlu
ZyAxIHByb2JlLi4uDQo+Pj4NCj4+PiBQcm9ncmFtIElEOiAyOTUNCj4+Pg0KPj4+IFRoZSB2
ZXJpZmllciBsb2c6DQo+Pj4gcHJvY2Vzc2VkIDUwIGluc25zIChsaW1pdCAxMDAwMDAwKSBt
YXhfc3RhdGVzX3Blcl9pbnNuIDAgdG90YWxfc3RhdGVzIDMNCj4+PiBwZWFrX3N0YXRlcyAz
IG1hcmtfcmVhZCAxDQo+Pj4NCj4+PiBBdHRhY2hpbmcga2Z1bmM6dm1saW51eDpiZWdpbl9u
ZXdfZXhlYw0KPj4+IEVSUk9SOiBFcnJvciBhdHRhY2hpbmcgcHJvYmU6IGtmdW5jOnZtbGlu
dXg6YmVnaW5fbmV3X2V4ZWMNCj4+IE9LLCBJIGNvdWxkIHJlcHJvZHVjZSB0aGlzIGlzc3Vl
IGFuZCBmb3VuZCB0aGUgaXNzdWUuIEluIG15IHRlc3QsDQo+PiBmZXhpdCtsaXZlcGF0Y2gg
d29ya3Mgb24gc29tZSBvbGRlciBrZXJuZWwsIGJ1dCBmYWlscyBvbiBzb21lIG5ld2VyDQo+
PiBrZXJuZWwuIEkgaGF2ZW4ndCBiaXNlY3RlZCB0byB0aGUgY29tbWl0IHRoYXQgYnJva2Ug
aXQuDQo+Pg0KPj4gU29tZXRoaW5nIGxpa2UgdGhlIGZvbGxvd2luZyBtYWtlIGl0IHdvcms6
DQo+Pg0KPj4gZGlmZiAtLWdpdCBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYyB3L2tlcm5lbC90
cmFjZS9mdHJhY2UuYw0KPj4gaW5kZXggMmUxMTNmOGIxM2EyLi40Mjc3YjRmMzNlYjggMTAw
NjQ0DQo+PiAtLS0gaS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+ICsrKyB3L2tlcm5lbC90
cmFjZS9mdHJhY2UuYw0KPj4gQEAgLTU5ODUsNiArNTk4NSw4IEBAIGludCByZWdpc3Rlcl9m
dHJhY2VfZGlyZWN0KHN0cnVjdCBmdHJhY2Vfb3BzDQo+PiAqb3BzLCB1bnNpZ25lZCBsb25n
IGFkZHIpDQo+PiAgICAgICAgICBvcHMtPmRpcmVjdF9jYWxsID0gYWRkcjsNCj4+DQo+PiAg
ICAgICAgICBlcnIgPSByZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb25fbm9sb2NrKG9wcyk7DQo+
PiArICAgICAgIGlmIChlcnIpDQo+PiArICAgICAgICAgICAgICAgcmVtb3ZlX2RpcmVjdF9m
dW5jdGlvbnNfaGFzaChkaXJlY3RfZnVuY3Rpb25zLCBhZGRyKTsNCj4+DQo+PiAgICBvdXRf
dW5sb2NrOg0KPj4gICAgICAgICAgbXV0ZXhfdW5sb2NrKCZkaXJlY3RfbXV0ZXgpOw0KPj4N
Cj4+IEFuZHJleSwgY291bGQgeW91IGFsc28gdGVzdCB0aGlzIGNoYW5nZT8NCj4gQXR0YWNo
ZWQgaXMgYSBiZXR0ZXIgdmVyc2lvbiBvZiB0aGUgZml4Lg0KPg0KPiBUaGFua3MsDQo+IFNv
bmcNCg0KVGhhbmsgeW91IFNvbmchDQoNClNvLCB3aXRoIHRoaXMgWW91IHNheSBib3RoIGZl
bnRyeSBhbmQgZmV4aXQgd2lsbCB3b3JrIG5vIGlzc3VlcyA/DQoNClNvIGp1dHMgdG8gdW5k
ZXJzdGFuZCwgYXMgaSBhbSBub3QgZmFtaWxpYXIgd2l0aCBsaXZlLXBhdGNoIGdlbmVyYXRp
b24sIA0KSSBnZXQgdGhlIHNvdXJjZXMgZm9yIG15IFVidW50dSBrZXJuZWwsIEkgYXBwbHkg
eW91ciBwYXRjaCwgSSBhbHNvIA0KZ2VuZXJhdGUgbWFudWFsbHkgbGl2ZXBhdGNoIG1vZHVs
ZSB0aGF0IG1ha2VzIGEgZHVtbXkgcGF0Y2hpbmcgdG8gbXkgDQp0ZXN0IGZ1bmN0aW9uIChi
ZWdpbl9uZXdfZXhlYyksIGFuZCBhcHBseSB0aGlzIHBhdGNoIHRvIG15IHJ1bm5pbmcgDQpj
b3N0dW0ga2VybmVsID8gQmVjYXVzZSBpIGRvbid0IHRoaW5rIHRoZSBzdGFkYXJkIHVidW50
dSBsaXZlcGF0Y2hpbmcgDQp3aWxsIGFncmVlIHRvIGFwcGx5IGhpcyBsaXZlcGF0Y2ggQ1ZF
cyB0byBteSBvc3R1bSBrZW5lbCwgaXQgd2lsbCANCnByb2JhYmx5IHJlY29nbml6ZSBpdCdz
IG5vdCBzdG9jayB1YnVudHUga2VybmVsIGJ1dCBhbWFudWxseSBidWlsdCBvbmUuDQoNClRo
YW5rcywNCkFuZHJleQ0KDQpTbyBpIG5lZWQgdG8gYnVpbGQgdGhlIHN0YWJsZQ0KDQo=

