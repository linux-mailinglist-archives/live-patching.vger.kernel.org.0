Return-Path: <live-patching+bounces-1765-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B9CBF1F2A
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 16:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E46E3B8DAC
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 14:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584F9227E95;
	Mon, 20 Oct 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="blH3bjOg"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00206402.pphosted.com (mx0b-00206402.pphosted.com [148.163.152.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53087182D0
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.152.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760972190; cv=none; b=trUyI3c95XBoPkpQq2eWTOu47Qy5pVooehJBMD8q/05SCyAhe1MV6v7sr3TqYFTbpOjczBau2Gc6naljTVawF/V3Jas6gAh9pkw0gLCmssLTZJWeaopB27mQveD+AHCumFv5k3KBFnr7Kp8Qsn94177gthhr069I/PLF3zrafVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760972190; c=relaxed/simple;
	bh=hMQ3FgGJULDlirvxd+AIzEYSlZfhZacmDLQEOwWirLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hQRDwx4wTiu4yrFwoqWFeQN83HwCvrqx60FCw8btnSjtbAs/9tr2jh7j3Kfhv0AaEKcC8V+nTKxcapJUMgAaQPQYmrp2fUbGwT2kmQ6rgfLqiREUOSf64v6C+olj6KSCqM15t9kOVfHWenSRsX6BdpmkPEErsb1DeN45lgiqnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=blH3bjOg; arc=none smtp.client-ip=148.163.152.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354655.ppops.net [127.0.0.1])
	by mx0b-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KEkVhZ009210;
	Mon, 20 Oct 2025 14:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=hMQ3FgGJULDlirvxd+AIzEYSlZfhZacmDLQEOwWirLU=; b=blH3
	bjOggQnu+6LD7J3o4ep/qFL4G61CZIVIZD2P32+FTxjmmLNGHhyNLAQj9DHcfZrM
	FwCGCLwLh0UeSzmIVlZFYgyQUrnM8XJ6khV4rQv+BspV1pxlfvJhdeLUM7e3EEyA
	UTg0jjEqNToF9+CrK0O0miCO0zu5677DCcqRGYgU5yDltD9NviIKsLZGi/wmWjkB
	o8akpaiEtggkiLSjPE2/uT1XvL2LV5sKbPiXpaNCV7sy8Cw1ZbcQMAY9RmJRK2rt
	X5ePqtsHq3S2JdKwL+EkELX2GPKK3vBZosBozGn5Z/1+rM5hMVOmt8t5/uT6Exi0
	wjUrQVLYywnW5E270w==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0b-00206402.pphosted.com (PPS) with ESMTPS id 49vq5bjyed-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 14:56:08 +0000 (GMT)
Received: from [10.82.61.83] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 20 Oct
 2025 14:56:06 +0000
Message-ID: <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
Date: Mon, 20 Oct 2025 10:56:04 -0400
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
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
 <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH006.crowdstrike.sys (10.100.11.70) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Proofpoint-GUID: Tu0jmZSQHjpw-NasLl4vs2GT4DsfBz2h
X-Authority-Analysis: v=2.4 cv=BsiQAIX5 c=1 sm=1 tr=0 ts=68f64d88 cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pl6vuDidAAAA:8 a=VwQbUJbxAAAA:8
 a=f3vEgotgTPPbaZPDP1oA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Tu0jmZSQHjpw-NasLl4vs2GT4DsfBz2h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDAxNCBTYWx0ZWRfX72rD3U1FX63j
 vi2JAMWEDhyj83sP9jF1OPsB6o2j5XcdzFBzO54gXuhnBYP5kvZ1ZhoP5bsmAH3MgQ0c8x2X7a8
 B/jFOOyopoP0EZPMKj8BfjgzmYOLZB5edj3sXeKX0INjDU3U1Hw4nxCyhM/+SMXRNt7+rHmtXVj
 PB6oJTFV9osJ8954355e/dDhyqU87o9OcUgdOvDawthI2xIzj9uiLSMrY9ehwVDb8JDj4+U1QOV
 4u13PhyvqsmwQPxQUT/DYvOseRafDitAW012fxpBPvKV8RFRdbEa7hGjtv3pDn7N8lsLReC/a6l
 0Btpu1h/yqZGH58p2/oFWhF6odfyzlfQWo8BfyInEBP3W4h8CB1rHrwTaC2E9a4M3wBM2YHbMHo
 FyoU9yqCBiTGE4brUp0Q6olqOSqE/g==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11588
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510190014

T24gMTAvMTcvMjUgMTc6MTEsIFNvbmcgTGl1IHdyb3RlOg0KPiBPbiBGcmksIE9jdCAxNywg
MjAyNSBhdCAxMjo0OOKAr1BNIEFuZHJleSBHcm9kem92c2t5DQo+IDxhbmRyZXkuZ3JvZHpv
dnNreUBjcm93ZHN0cmlrZS5jb20+IHdyb3RlOg0KPj4gT24gMTAvMTcvMjUgMTU6MDcsIFNv
bmcgTGl1IHdyb3RlOg0KPj4+IE9uIEZyaSwgT2N0IDE3LCAyMDI1IGF0IDk6NTjigK9BTSBT
b25nIExpdSA8c29uZ0BrZXJuZWwub3JnPiB3cm90ZToNCj4+Pj4gT24gVGh1LCBPY3QgMTYs
IDIwMjUgYXQgMjo1NeKAr1BNIEFuZHJleSBHcm9kem92c2t5DQo+Pj4+IDxhbmRyZXkuZ3Jv
ZHpvdnNreUBjcm93ZHN0cmlrZS5jb20+IHdyb3RlOg0KPj4+PiBbLi4uXQ0KPj4+Pj4gW0FH
XSAtIFRyeWluZyBmaXJzdCB0byBwb2ludCBoaW0gYXQgdGhlIG9yaWdpbmFsICBmdW5jdGlv
biAtIGJ1dCBoZQ0KPj4+Pj4gZmFpbHMgb24gdGhlIGZleGl0IEkgYXNzdW1lICAtIHdoaWNo
IGlzIHN0cmFuZ2UsIEkgYXNzdW1lZCBmZXhpdA0KPj4+Pj4gKGtyZXRmdW5jKSBhbmQgbGl2
ZXBhdGNoIGNhbiBjb2V4aXN0ID8NCj4+Pj4+DQo+Pj4+PiB1YnVudHVAaXAtMTAtMTAtMTE0
LTIwNDp+JCBzdWRvIGJwZnRyYWNlIC1lDQo+Pj4+PiAnZmVudHJ5OnZtbGludXg6YmVnaW5f
bmV3X2V4ZWMgeyBAc3RhcnRbdGlkXSA9IG5zZWNzOyBwcmludGYoIi0+IEVYRUMNCj4+Pj4+
IFNUQVJUIChmZW50cnkpOiBQSUQgJWQsIENvbW0gJXNcbiIsIHBpZCwgY29tbSk7IH0NCj4+
Pj4+IGZleGl0OnZtbGludXg6YmVnaW5fbmV3X2V4ZWMgeyAkbGF0ZW5jeSA9IG5zZWNzIC0g
QHN0YXJ0W3RpZF07DQo+Pj4+PiBkZWxldGUoQHN0YXJ0W3RpZF0pOyBwcmludGYoIjwtIEVY
RUMgRU5EIChmZXhpdCk6IFBJRCAlZCwgQ29tbSAlcywNCj4+Pj4+IFJldHZhbCAlZCwgTGF0
ZW5jeSAlZCB1c1xuIiwgcGlkLCBjb21tLCByZXR2YWwsICRsYXRlbmN5IC8gMTAwMCk7IH0n
DQo+Pj4+PiBBdHRhY2hpbmcgMiBwcm9iZXMuLi4NCj4+Pj4+IEVSUk9SOiBFcnJvciBhdHRh
Y2hpbmcgcHJvYmU6IGtyZXRmdW5jOnZtbGludXg6YmVnaW5fbmV3X2V4ZWMNCj4+Pj4+DQo+
Pj4+PiBbQUddIC0gVHJ5aW5nIHRvIHNraXAgdGhlIGZleGl0IGFuZCBvbmx5IGRvIGZlbnRy
eSAtIGhlIHN0aWxsIHJlamVjdHMNCj4+Pj4+IHVidW50dUBpcC0xMC0xMC0xMTQtMjA0On4k
IHN1ZG8gYnBmdHJhY2UgLXZ2diAtZQ0KPj4+Pj4gJ2ZlbnRyeTp2bWxpbnV4OmJlZ2luX25l
d19leGVjIHsgQHN0YXJ0W3RpZF0gPSBuc2VjczsgcHJpbnRmKCItPiBFWEVDDQo+Pj4+PiBT
VEFSVCAoZmVudHJ5KTogUElEICVkLCBDb21tICVzXG4iLCBwaWQsIGNvbW0pOyB9Jw0KPj4+
Pj4gc3VkbzogdW5hYmxlIHRvIHJlc29sdmUgaG9zdCBpcC0xMC0xMC0xMTQtMjA0OiBUZW1w
b3JhcnkgZmFpbHVyZSBpbiBuYW1lDQo+Pj4+PiByZXNvbHV0aW9uDQo+Pj4+PiBJTkZPOiBu
b2RlIGNvdW50OiAxMg0KPj4+Pj4gQXR0YWNoaW5nIDEgcHJvYmUuLi4NCj4+Pj4+DQo+Pj4+
PiBQcm9ncmFtIElEOiAyOTUNCj4+Pj4+DQo+Pj4+PiBUaGUgdmVyaWZpZXIgbG9nOg0KPj4+
Pj4gcHJvY2Vzc2VkIDUwIGluc25zIChsaW1pdCAxMDAwMDAwKSBtYXhfc3RhdGVzX3Blcl9p
bnNuIDAgdG90YWxfc3RhdGVzIDMNCj4+Pj4+IHBlYWtfc3RhdGVzIDMgbWFya19yZWFkIDEN
Cj4+Pj4+DQo+Pj4+PiBBdHRhY2hpbmcga2Z1bmM6dm1saW51eDpiZWdpbl9uZXdfZXhlYw0K
Pj4+Pj4gRVJST1I6IEVycm9yIGF0dGFjaGluZyBwcm9iZToga2Z1bmM6dm1saW51eDpiZWdp
bl9uZXdfZXhlYw0KPj4+PiBPSywgSSBjb3VsZCByZXByb2R1Y2UgdGhpcyBpc3N1ZSBhbmQg
Zm91bmQgdGhlIGlzc3VlLiBJbiBteSB0ZXN0LA0KPj4+PiBmZXhpdCtsaXZlcGF0Y2ggd29y
a3Mgb24gc29tZSBvbGRlciBrZXJuZWwsIGJ1dCBmYWlscyBvbiBzb21lIG5ld2VyDQo+Pj4+
IGtlcm5lbC4gSSBoYXZlbid0IGJpc2VjdGVkIHRvIHRoZSBjb21taXQgdGhhdCBicm9rZSBp
dC4NCj4+Pj4NCj4+Pj4gU29tZXRoaW5nIGxpa2UgdGhlIGZvbGxvd2luZyBtYWtlIGl0IHdv
cms6DQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgaS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMgdy9r
ZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+Pj4gaW5kZXggMmUxMTNmOGIxM2EyLi40Mjc3YjRm
MzNlYjggMTAwNjQ0DQo+Pj4+IC0tLSBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4+PiAr
Kysgdy9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+Pj4gQEAgLTU5ODUsNiArNTk4NSw4IEBA
IGludCByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KHN0cnVjdCBmdHJhY2Vfb3BzDQo+Pj4+ICpv
cHMsIHVuc2lnbmVkIGxvbmcgYWRkcikNCj4+Pj4gICAgICAgICAgIG9wcy0+ZGlyZWN0X2Nh
bGwgPSBhZGRyOw0KPj4+Pg0KPj4+PiAgICAgICAgICAgZXJyID0gcmVnaXN0ZXJfZnRyYWNl
X2Z1bmN0aW9uX25vbG9jayhvcHMpOw0KPj4+PiArICAgICAgIGlmIChlcnIpDQo+Pj4+ICsg
ICAgICAgICAgICAgICByZW1vdmVfZGlyZWN0X2Z1bmN0aW9uc19oYXNoKGRpcmVjdF9mdW5j
dGlvbnMsIGFkZHIpOw0KPj4+Pg0KPj4+PiAgICAgb3V0X3VubG9jazoNCj4+Pj4gICAgICAg
ICAgIG11dGV4X3VubG9jaygmZGlyZWN0X211dGV4KTsNCj4+Pj4NCj4+Pj4gQW5kcmV5LCBj
b3VsZCB5b3UgYWxzbyB0ZXN0IHRoaXMgY2hhbmdlPw0KPj4+IEF0dGFjaGVkIGlzIGEgYmV0
dGVyIHZlcnNpb24gb2YgdGhlIGZpeC4NCj4+Pg0KPj4+IFRoYW5rcywNCj4+PiBTb25nDQo+
PiBUaGFuayB5b3UgU29uZyENCj4+DQo+PiBTbywgd2l0aCB0aGlzIFlvdSBzYXkgYm90aCBm
ZW50cnkgYW5kIGZleGl0IHdpbGwgd29yayBubyBpc3N1ZXMgPw0KPiBZZXMsIGZlbnRyeSBh
bmQgZmV4aXQgc2hvdWxkIGJvdGggd29yay4NCj4NCj4+IFNvIGp1dHMgdG8gdW5kZXJzdGFu
ZCwgYXMgaSBhbSBub3QgZmFtaWxpYXIgd2l0aCBsaXZlLXBhdGNoIGdlbmVyYXRpb24sDQo+
PiBJIGdldCB0aGUgc291cmNlcyBmb3IgbXkgVWJ1bnR1IGtlcm5lbCwgSSBhcHBseSB5b3Vy
IHBhdGNoLCBJIGFsc28NCj4+IGdlbmVyYXRlIG1hbnVhbGx5IGxpdmVwYXRjaCBtb2R1bGUg
dGhhdCBtYWtlcyBhIGR1bW15IHBhdGNoaW5nIHRvIG15DQo+PiB0ZXN0IGZ1bmN0aW9uIChi
ZWdpbl9uZXdfZXhlYyksIGFuZCBhcHBseSB0aGlzIHBhdGNoIHRvIG15IHJ1bm5pbmcNCj4+
IGNvc3R1bSBrZXJuZWwgPyBCZWNhdXNlIGkgZG9uJ3QgdGhpbmsgdGhlIHN0YWRhcmQgdWJ1
bnR1IGxpdmVwYXRjaGluZw0KPj4gd2lsbCBhZ3JlZSB0byBhcHBseSBoaXMgbGl2ZXBhdGNo
IENWRXMgdG8gbXkgb3N0dW0ga2VuZWwsIGl0IHdpbGwNCj4+IHByb2JhYmx5IHJlY29nbml6
ZSBpdCdzIG5vdCBzdG9jayB1YnVudHUga2VybmVsIGJ1dCBhbWFudWxseSBidWlsdCBvbmUu
DQo+IGxpdmVwYXRjaCBpcyBhIGtlcm5lbCBtb2R1bGUuIFRoZXJlZm9yZSwgdW5sZXNzIHRo
ZSB0d28ga2VybmVscyBhcmUgYWxtb3N0DQo+IGlkZW50aWNhbCwgbGl2ZXBhdGNoIGJ1aWx0
IGZvciBvbmUga2VybmVsIGNhbm5vdCBiZSB1c2VkIG9uIHRoZSBvdGhlci4NCj4NCj4gSWYg
eW91IGJ1aWxkIHRoZSBrZXJuZWwgZnJvbSBzb3VyY2UgY29kZSwgdGhlcmUgYXJlIHNvbWUg
c2FtcGxlcyBpbg0KPiBzYW1wbGVzL2xpdmVwYXRjaCB0aGF0IHlvdSBjYW4gdXNlIGZvciB0
ZXN0aW5nLiBQUzogWW91IG5lZWQgdG8gZW5hYmxlDQo+DQo+ICAgIENPTkZJR19TQU1QTEVf
TElWRVBBVENIPW0NCj4NCj4gSSBob3BlIHRoaXMgaGVscHMuDQoNClRoYW5rcyBTb25nLCB3
b3JraW5nIG9uIHJlcHJvLCBrZXJuZWwgcmVidWlsdCwgdGVzdCBtb2R1bGUgaXMgbG9hZGlu
ZyANCmJ1dCwgYnBmdHJhY2UgaXMgcmVmdXNpbmcgdG8gYXR0YWNoIG5vdyB0byBmZW50cmll
cy9mZXhpdHMgY2xhaW1pbmcgdGhlIA0KY29zdHVtIGtlcm5lbCBpcyBub3Qgc3VwcG9ydGlu
ZyBpdC4gSXQgZGlkDQphdHRhY2ggaW4gdGhlIGNhc2Ugb2Ygc3RvY2sgQVdTIGtlcm5lbCBp
IGNvcGllZCB0aGUgLmNvbmZpZyBmcm9tLiBTbyANCmp1c3QgdHJ5aW5nIHRvIGZpZ3VyZSBv
dXQgbm93IGlmIHNvbWUgS2NvZm5pZyBmbGFncyBhcmUgbWlzc2luZyBvciANCmRpZmZlcmVu
dCAuIExldCBtZSBrbm93IGluIGNhc2UgeW91IG1hbmFnZSB0byBjb25maXJtIHlvdXJzZWxm
IGluIHRoZSANCm1lYW53aGlsZSB0aGUgZml4IHdvcmtzIGZvcg0KeW91Lg0KDQpUaGFua3Ms
DQpBbmRyZXkNCg0KDQo+DQo+IFRoYW5rcywNCj4gU29uZw0KDQoNCg==

