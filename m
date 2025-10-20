Return-Path: <live-patching+bounces-1776-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F725BF3497
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 21:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D10084E2227
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 19:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339AF2874E6;
	Mon, 20 Oct 2025 19:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="nD9nnfJ/"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00206402.pphosted.com (mx0b-00206402.pphosted.com [148.163.152.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCFA25394B
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 19:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.152.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760990016; cv=none; b=Hvq2vXI0fv/sTGh16cXUmQ1qHBbVQGAB90kVx82JnVs38MqUoPYo2Msnx9ImSE2eTmbLGNCwYkSxMAFPpL8XAAIFYEQvmB6GBILVwqlzB442g0UUQdMvon4e/61OqFCM2t9W+DKL0BXVoCPhAEEW5wFQ1/9G62RHMHw5TTw7yPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760990016; c=relaxed/simple;
	bh=telu/2B6hAza0NhJzIcRc66/7Psyyrw7exzohOuN7e8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ZlEy0xU5o7ILC0YhV/uD9CQSG0jUlaitTGzRMtlcq81zkSLTZw9VsAyE0+8aT7tkFmzEYOPhNzOLz2XQkQ+IxTD2xrLa4obzdsN7mTMr4N2Zh2/o4C+Soh7anzu2auF315eqWbVXR0szQ91FS7CYoSrUZOjJKh4NvUpQJN/lA00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=nD9nnfJ/; arc=none smtp.client-ip=148.163.152.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354654.ppops.net [127.0.0.1])
	by mx0b-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KI06IL017627;
	Mon, 20 Oct 2025 19:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=telu/2B6hAza0NhJzIcRc66/7Psyyrw7exzohOuN7e8=; b=nD9n
	nfJ/ON427gVkjtb+Oc8OX8TNaDhTdWEXcpkg9cc/hnCGn1z/aRhGSgR/uYx9PRh9
	QmlUGE1Y9kuDxdyrhhZdTPifegh3VNCWE5s7KQ5sm9UkkjUJmxz8RyzRcXhVxnXO
	kLIW8AVnTDOtK2oMAKsx+PLa0XJoPFZNH8hhNI+lXrrl6EK0RwkDCP3geuYNZmMl
	idihlnR2W6/IuIwUMQIvGVhX6jnsFRETMwRyHAubkPKuZlmHtCIzqqfX7idENstp
	U9eAlwR1u9XXzp2GLuwMYxQBCCfCQBnouUhELOahx8Ve/LCsO/LiQe0NP48uSVo+
	gSHNJEKTqTi0A+1GJA==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0b-00206402.pphosted.com (PPS) with ESMTPS id 49vnpxc0bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 19:53:26 +0000 (GMT)
Received: from [10.82.61.83] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 20 Oct
 2025 19:53:23 +0000
Message-ID: <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
Date: Mon, 20 Oct 2025 15:53:22 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
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
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
 <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
 <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
 <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
Content-Language: en-US
In-Reply-To: <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH008.crowdstrike.sys (10.100.11.75) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Authority-Analysis: v=2.4 cv=bPIb4f+Z c=1 sm=1 tr=0 ts=68f69336 cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8
 a=wasda3RHO8-KR_FsfU4A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: AZRk6sD_5hct2wD1RcEHAc9Ncgw9lhgB
X-Proofpoint-ORIG-GUID: AZRk6sD_5hct2wD1RcEHAc9Ncgw9lhgB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDAwMyBTYWx0ZWRfXygnIl+VTHnZX
 VX+bqL7pXM2pXnRJ30kyH/3H9OUat/OVjkyDlkl7xoGwASPyXH4DSN05xvQ9SsZ4mCspBjYqNhE
 77eDVNngrcD+3iWXzj5QbVjawMAWGDtGTVmtWdbCe47NvyA9+nmg5XBuAE40vqZxeBX13XvINqd
 pYA6qe2C1oA4IKHssJ7M2xsEXSCu7nvWVJjcgz7QvK6g174Mtz7tciquVgopcrkY+QyrZSQBzbp
 ViAyVat5Um3GffpzGpYITL5U1cLz+jQ9eEkosj79xATgCQS4nICS8k5C/0j47LNXwEiooJ5dSgn
 4wN8LW/4bS9SpBlhawiI8anpBSGKMvG8T1sq178KYQKZAv0w62a9UFSvwUlRZTVEOZgPhkifSb0
 SuuzCVnmlSMACLQ1dfB6q6rurMo1Lw==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11588
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510190003

T24gMTAvMjAvMjUgMTU6MTAsIEFuZHJleSBHcm9kem92c2t5IHdyb3RlOg0KPiBPbiAxMC8y
MC8yNSAxNDo1MywgU29uZyBMaXUgd3JvdGU6DQo+PiBPbiBNb24sIE9jdCAyMCwgMjAyNSBh
dCA5OjQ14oCvQU0gQW5kcmV5IEdyb2R6b3Zza3kNCj4+IDxhbmRyZXkuZ3JvZHpvdnNreUBj
cm93ZHN0cmlrZS5jb20+IHdyb3RlOg0KPj4+IE9uIDEwLzIwLzI1IDEyOjAzLCBTb25nIExp
dSB3cm90ZToNCj4+Pj4gT24gTW9uLCBPY3QgMjAsIDIwMjUgYXQgNzo1NuKAr0FNIEFuZHJl
eSBHcm9kem92c2t5DQo+Pj4+IDxhbmRyZXkuZ3JvZHpvdnNreUBjcm93ZHN0cmlrZS5jb20+
IHdyb3RlOg0KPj4+PiBbLi4uXQ0KPj4+Pj4+IElmIHlvdSBidWlsZCB0aGUga2VybmVsIGZy
b20gc291cmNlIGNvZGUsIHRoZXJlIGFyZSBzb21lIHNhbXBsZXMgaW4NCj4+Pj4+PiBzYW1w
bGVzL2xpdmVwYXRjaCB0aGF0IHlvdSBjYW4gdXNlIGZvciB0ZXN0aW5nLiBQUzogWW91IG5l
ZWQgdG8gDQo+Pj4+Pj4gZW5hYmxlDQo+Pj4+Pj4NCj4+Pj4+PiDCoMKgwqDCoCBDT05GSUdf
U0FNUExFX0xJVkVQQVRDSD1tDQo+Pj4+Pj4NCj4+Pj4+PiBJIGhvcGUgdGhpcyBoZWxwcy4N
Cj4+Pj4+IFRoYW5rcyBTb25nLCB3b3JraW5nIG9uIHJlcHJvLCBrZXJuZWwgcmVidWlsdCwg
dGVzdCBtb2R1bGUgaXMgbG9hZGluZw0KPj4+Pj4gYnV0LCBicGZ0cmFjZSBpcyByZWZ1c2lu
ZyB0byBhdHRhY2ggbm93IHRvIGZlbnRyaWVzL2ZleGl0cyANCj4+Pj4+IGNsYWltaW5nIHRo
ZQ0KPj4+Pj4gY29zdHVtIGtlcm5lbCBpcyBub3Qgc3VwcG9ydGluZyBpdC4gSXQgZGlkDQo+
Pj4+PiBhdHRhY2ggaW4gdGhlIGNhc2Ugb2Ygc3RvY2sgQVdTIGtlcm5lbCBpIGNvcGllZCB0
aGUgLmNvbmZpZyBmcm9tLiBTbw0KPj4+Pj4ganVzdCB0cnlpbmcgdG8gZmlndXJlIG91dCBu
b3cgaWYgc29tZSBLY29mbmlnIGZsYWdzIGFyZSBtaXNzaW5nIG9yDQo+Pj4+PiBkaWZmZXJl
bnQgLiBMZXQgbWUga25vdyBpbiBjYXNlIHlvdSBtYW5hZ2UgdG8gY29uZmlybSB5b3Vyc2Vs
ZiBpbiB0aGUNCj4+Pj4+IG1lYW53aGlsZSB0aGUgZml4IHdvcmtzIGZvcg0KPj4+Pj4geW91
Lg0KPj4+PiBZZXMsIGl0IHdvcmtlZCBpbiBteSB0ZXN0cy4NCj4+Pj4NCj4+Pj4gW3Jvb3RA
KG5vbmUpIC9dIyBrcGF0Y2ggbG9hZCANCj4+Pj4gbGludXgvc2FtcGxlcy9saXZlcGF0Y2gv
bGl2ZXBhdGNoLXNhbXBsZS5rbw0KPj4+PiBsb2FkaW5nIHBhdGNoIG1vZHVsZTogbGludXgv
c2FtcGxlcy9saXZlcGF0Y2gvbGl2ZXBhdGNoLXNhbXBsZS5rbw0KPj4+PiBbcm9vdEAobm9u
ZSkgL10jIGJwZnRyYWNlLnJlYWwgLWUgJ2ZleGl0OmNtZGxpbmVfcHJvY19zaG93DQo+Pj4+
IHtwcmludGYoImZleGl0XG4iKTt9JyAmDQo+Pj4+IFsxXSAzODgNCj4+Pj4gW3Jvb3RAKG5v
bmUpIC9dIyBBdHRhY2hlZCAxIHByb2JlDQo+Pj4+IFtyb290QChub25lKSAvXSMgYnBmdHJh
Y2UucmVhbCAtZSAnZmVudHJ5OmNtZGxpbmVfcHJvY19zaG93DQo+Pj4+IHtwcmludGYoImZl
bnRyeVxuIik7fScgJg0KPj4+PiBbMl0gMzk3DQo+Pj4+IFtyb290QChub25lKSAvXSMgQXR0
YWNoZWQgMSBwcm9iZQ0KPj4+Pg0KPj4+PiBbcm9vdEAobm9uZSkgL10jIGNhdCAvcHJvYy9j
bWRsaW5lDQo+Pj4+IHRoaXMgaGFzIGJlZW4gbGl2ZSBwYXRjaGVkDQo+Pj4+IGZlbnRyeQ0K
Pj4+PiBmZXhpdA0KPj4+Pg0KPj4+PiBUaGFua3MsDQo+Pj4+IFNvbmcNCj4+Pj4NCj4+PiBW
ZXJpZmllZCB0aGUgZmFpbHVyZXMgSSBvYnNlcnZlIHdoZW4gdHJ5aW5nIHRvIGF0dGFjaCB3
aXRoIEJQRiB0cmFjZSANCj4+PiBhcmUNCj4+PiBvbmx5IGluIHByZXNlbmNlIG9mIHBhdGNo
IHlvdSBwcm92aWRlZC4NCj4+PiBQbGVhc2Ugc2VlIGF0dGFjaGVkIGRtZXNnIGZvciBmYWls
dXJlcy4gSW5pdGlhbCB3YXJuaW5nIG9uIGJvb3QuDQo+Pj4gU3Vic2VxdWVidCB3YXJuaW5n
cyBhbmQgZXJyb3JzIGF0IHRoZSBwb2ludCBpIHRyeSB0byBydW4NCj4+PiBzdWRvIGJwZnRy
YWNlIC1lICJmZXhpdDpjbWRsaW5lX3Byb2Nfc2hvdyB7IHByaW50ZihcImZleGl0IGhpdFxc
blwiKTsNCj4+PiBleGl0KCk7IH0iDQo+Pj4NCj4+PiBzdWRvOiB1bmFibGUgdG8gcmVzb2x2
ZSBob3N0IGlwLTEwLTEwLTExNS0yMzg6IFRlbXBvcmFyeSBmYWlsdXJlIGluIA0KPj4+IG5h
bWUNCj4+PiByZXNvbHV0aW9uDQo+Pj4gc3RkaW46MToxLTI1OiBFUlJPUjoga2Z1bmMva3Jl
dGZ1bmMgbm90IGF2YWlsYWJsZSBmb3IgeW91ciBrZXJuZWwgDQo+Pj4gdmVyc2lvbi4NCj4+
Pg0KPj4+IHVidW50dUBpcC0xMC0xMC0xMTUtMjM4On4vbGludXgtNi44LjEkIHN1ZG8gY2F0
DQo+Pj4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9hdmFpbGFibGVfZmlsdGVyX2Z1bmN0
aW9ucyB8IGdyZXANCj4+PiBjbWRsaW5lX3Byb2Nfc2hvdw0KPj4+IHN1ZG86IHVuYWJsZSB0
byByZXNvbHZlIGhvc3QgaXAtMTAtMTAtMTE1LTIzODogVGVtcG9yYXJ5IGZhaWx1cmUgaW4g
DQo+Pj4gbmFtZQ0KPj4+IHJlc29sdXRpb24NCj4+PiBjYXQ6IC9zeXMva2VybmVsL2RlYnVn
L3RyYWNpbmcvYXZhaWxhYmxlX2ZpbHRlcl9mdW5jdGlvbnM6IE5vIHN1Y2ggDQo+Pj4gZGV2
aWNlDQo+Pj4NCj4+PiBBZnRlciByZWJvb3QgYW5kIGJlZm9yZSB0cnlpbmcgdG8gYXR0YWNn
IHdpdGggYnBmdHJhY2UsDQo+Pj4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9hdmFpbGFi
bGVfZmlsdGVyX2Z1bmN0aW9ucyBpcyBhdmFpbGFibGUgYW5kDQo+Pj4gc2hvd3MgYWxsIGZ1
bmN0aW9uLg0KPj4+DQo+Pj4gVXNpbmcgc3RhYmxlIGtlcm5lbCBmcm9tDQo+Pj4gaHR0cHM6
Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vY2RuLmtlcm5lbC5vcmcvcHViL2xpbnV4
L2tlcm5lbC92Ni54L2xpbnV4LTYuOC4xLnRhci5nel9fOyEhQm1kelMzX2xWOUhkS0c4ITFa
SmU0alk0OV94SXpwNGg0aTRBYnFwa0xLb0FxclhMRlgyd0R4aG9TVURnMmtTZVRqeTNDT3k5
TW5nTkRSbFpoSjFvVUtnZjF5UHFtblRZOS1ZNTBUa0EkIA0KPj4+IGZvciBidWlsZC4NCj4+
PiBGVFJBQ0UgcmVsYXRlZCBLQ09ORklHcyBiZWxsb3cNCj4+IEkgY2FuIHNlZSB0aGUgc2lt
aWxhciBpc3N1ZSB3aXRoIHRoZSB1cHN0cmVhbSBrZXJuZWwuIEkgd2FzIHRlc3Rpbmcgb24N
Cj4+IHN0YWJsZSA2LjE3IGJlZm9yZSBqdXN0IGtub3cgYmVjYXVzZSBvZiBhbm90aGVyIGlz
c3VlIHdpdGggdXBzdHJlYW0NCj4+IGtlcm5lbCwgYW5kIHNvbWVob3cgNi4xNyBrZXJuZWwg
ZG9lc24ndCBzZWVtIHRvIGhhdmUgdGhlIGlzc3VlLg0KPj4NCj4+IFRvIGZpeCB0aGlzLCBJ
IHRoaW5rIHdlIHNob3VsZCBsYW5kIGEgZml4IHNpbWlsYXIgdG8gdGhlIGVhcmxpZXIgZGlm
ZjoNCj4+DQo+PiBkaWZmIC0tZ2l0IGkva2VybmVsL3RyYWNlL2Z0cmFjZS5jIHcva2VybmVs
L3RyYWNlL2Z0cmFjZS5jDQo+PiBpbmRleCA0MmJkMmJhNjhhODIuLjhmMzIwZGYwYWM1MiAx
MDA2NDQNCj4+IC0tLSBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gKysrIHcva2VybmVs
L3RyYWNlL2Z0cmFjZS5jDQo+PiBAQCAtNjA0OSw2ICs2MDQ5LDkgQEAgaW50IHJlZ2lzdGVy
X2Z0cmFjZV9kaXJlY3Qoc3RydWN0IGZ0cmFjZV9vcHMNCj4+ICpvcHMsIHVuc2lnbmVkIGxv
bmcgYWRkcikNCj4+DQo+PiDCoMKgwqDCoMKgwqDCoMKgIGVyciA9IHJlZ2lzdGVyX2Z0cmFj
ZV9mdW5jdGlvbl9ub2xvY2sob3BzKTsNCj4+DQo+PiArwqDCoMKgwqDCoMKgIGlmIChlcnIp
DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZW1vdmVfZGlyZWN0X2Z1bmN0
aW9uc19oYXNoKGhhc2gsIGFkZHIpOw0KPj4gKw0KPj4gwqDCoCBvdXRfdW5sb2NrOg0KPj4g
wqDCoMKgwqDCoMKgwqDCoCBtdXRleF91bmxvY2soJmRpcmVjdF9tdXRleCk7DQo+Pg0KPj4N
Cj4+IFN0ZXZlbiwNCj4+DQo+PiBEb2VzIHRoaXMgY2hhbmdlIGxvb2sgZ29vZCB0byB5b3U/
DQo+Pg0KPj4NCj4NCj4gU2VlbXMgcmVhc29uYWJsZSB0byBtZSwgd2UgYXJlIHNpbXBseSBj
bGVhbmluZyB0aGUgZW50cnkgb24gZmFpbHVyZSBzbyANCj4gd2UgZG9uJ3QgZW5jb3VudGVy
IGl0IGxhdGUgYW55bW9yZS4NCj4gU28gSSB3aWxsIGFwcGx5IHRoaXMgcGF0Y2ggT05MWSBh
bmQgcmV0ZXN0IC0gY29ycmVjdCA/DQo+DQo+IEFub3RoZXIgcXVlc3Rpb24gLSBpdCBzZWVt
cyB5b3UgZm91bmQgd2hlcmUgaXQgYnJva2UgPyBJIHNhdyAnQ2M6IA0KPiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnICMgdjYuNisnIGluIHlvdXIgcHJldi4gcGF0Y2guJw0KPiBJZiBzbyAs
IGNhbiB5b3UgcGxlYXNlIHBvaW50IG1lIHRvIHRoZSBvZmZlbmRpbmcgcGF0Y2ggc28gSSBh
ZGQgdGhpcyANCj4gdG8gbXkgcmVjb3JkcyBvZiBteSBkaXNjb3Zlcnkgd29yayBvZiBicGYg
Y29leGlzdGVuY2UNCj4gbGl2ZXBhdGNoaW5nID8NCj4NCj4gVGhhbmtzLA0KPg0KPiBBbmRy
ZXkNCg0KDQpVcGRhdGUgLSB3aXRoIGxhdGVzdCBmaXggd29yayBmaW5kLCBib3RoIGFmdGVy
IGxvYWRpbmcgdGhlIGxpdmVwYXRjaCANCi5rb8KgIG5vIGNvbmZsaWN0cyBhbmQgaG9va3Mg
d29yayBhbmQsDQpiZWZvcmUgbG9hZGluZyBpdCwgcHJlIGV4c2lzdGluZyBob29rcyBrZWVw
IHdvcmtpbmcgYWZ0ZXIgdGhlIHBhdGNoIGlzIA0KbG9hZGVkDQoNCllvdSBjYW4gYWRkIEFj
a2VkLWFuZC10ZXN0ZWQtYnk6IEFuZHJleSBHcm9kem92c2t5IA0KPGFuZHJleS5ncm9kem92
c2t5QGNyb3dkc3RyaWtlLmNvbT4NCg0KT25jZSBhZ2FpbiwgaW4gY2FzZSB5b3Ugbm93IHRo
ZSBleGFjdCBjb21taXQgdGhhdCBicm9rZSBpdCwgcGxlYXNlIGxldCANCm1lIGtub3cuDQoN
ClRoYW5rcywNCkFuZHJleQ0KDQo+DQo+Pg0KPj4gVGhhbmtzLA0KPj4gU29uZw0KPg0KPg0K
DQo=

