Return-Path: <live-patching+bounces-1780-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C001BF3C1A
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 23:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8038D4FD572
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 21:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A9D1DF985;
	Mon, 20 Oct 2025 21:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="hUOtlLBf"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00206402.pphosted.com (mx0a-00206402.pphosted.com [148.163.148.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133E3EA8D
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.148.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760995878; cv=none; b=AyQaubfmYKf7CjARJqbbyOkqE7vcQV+HSVvXtM4wzu7pfiv9xFfqY4m1w4BG175HlHpBWYCxIkrI0GaGU/n5qdYX3JwJdEMCJ1Z2Fu/YRH0hdTLDfJQR08nNxtvV/m3aUL7Q9zJYSpjmER5xbYb86lCuR0+37fOK8SxlR1rdYK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760995878; c=relaxed/simple;
	bh=fx+q63Ra3HiMF3JAbbXR0CJd9K2txinms+JcD1TA3sg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=k7mW4mrH8C6dCdBdHt4hWQu797GFwu78BQkM3fMxaJ098qGYB6ukBe3nIMxycj8sUZrxMtK9vqLQ68L0PxXXotOnrImhDoXEylodeVd6ZyA8rnYMyUVGwJRDFF/PWbhCuG3+CR+Vt+2KlCq+uNWhQbqZ2u4qI70VV6LkZyXeHtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=hUOtlLBf; arc=none smtp.client-ip=148.163.148.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354652.ppops.net [127.0.0.1])
	by mx0a-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KHbtUZ013874;
	Mon, 20 Oct 2025 21:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=fx+q63Ra3HiMF3JAbbXR0CJd9K2txinms+JcD1TA3sg=; b=hUOt
	lLBfaxjICB84KhKkdVc7dMm8S4iB8y3s6hDRU9mvY6sg+gjfKRBQyJQH71nCnmgt
	c+4nV05PjZygocxSaRKqisO/pZ+8Y41WPY7ZCRggGckTi0FmmpZhJ6pu/wO5UfyX
	s216OkdMFqnX0FovKf9woZSh93F0XEnQNgnjsO2Fz6gzvy370RkmP1Y62Iooep+3
	ZeKPmZK3nG93SevZDTuqrBwQD9peSvobmNeWKov2VHAXc0f6DVPMVl7y8b+TFLva
	OVZ7vrRkOKnq+8frACbYLmABe2wnA5tNNbpXm0l0NwzNWeyg9QInHI7iqNLnr4LB
	wDMwKNowwa+J3upEGw==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0a-00206402.pphosted.com (PPS) with ESMTPS id 49vrq0cdte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 21:31:07 +0000 (GMT)
Received: from [10.82.61.83] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 20 Oct
 2025 21:31:05 +0000
Message-ID: <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com>
Date: Mon, 20 Oct 2025 17:31:04 -0400
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
 <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
Content-Language: en-US
In-Reply-To: <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH008.crowdstrike.sys (10.100.11.75) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Proofpoint-GUID: h93S6cLVysjuaPJd3OdFN1_2f9bAW1xp
X-Authority-Analysis: v=2.4 cv=ANhDx8K4 c=1 sm=1 tr=0 ts=68f6aa1b cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8
 a=VFlhiWZDmpswK1jzOdQA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDAyNiBTYWx0ZWRfXyPTXwozZscB1
 gPQ/QRg1bCeObjCH27xya3yiL1s+xX8ErdLg4qetpyIO+VoKgRsRfmP9vibwZd2XPIZN+evPtey
 /u4bo7em+RK15VNkW9JJsvEImrfzoylKxQ0eOorfbHeT1SXWWcL5p+oqFtzV36UKksHzUMVcS3X
 Vx5Hs0nyDayBa825u3DepI4nHbWGiVk0rV54+kgkxQR4JxKKjGyPHJ0FQpdUC9QfAQbGd7ysh2D
 uP4zfLFDNzvUhfl8cYwKXzB58R+7MmkPTydfp+TzVNxGVODQ+BnScAYhh0ODDmF8BgWjtg+dre2
 H/G4lZKMyY5Cjezax0h4h7ie1Ig340C8iS0P+cujWsCS2OJWExIYvnCR9HB/UDRJ+pMhZmE4z7B
 N/vvIDRTgz2wJeBJrMbWLZ1xdEpF5Q==
X-Proofpoint-ORIG-GUID: h93S6cLVysjuaPJd3OdFN1_2f9bAW1xp
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11588
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510190026

T24gMTAvMjAvMjUgMTU6NTMsIEFuZHJleSBHcm9kem92c2t5IHdyb3RlOg0KPiBPbiAxMC8y
MC8yNSAxNToxMCwgQW5kcmV5IEdyb2R6b3Zza3kgd3JvdGU6DQo+PiBPbiAxMC8yMC8yNSAx
NDo1MywgU29uZyBMaXUgd3JvdGU6DQo+Pj4gT24gTW9uLCBPY3QgMjAsIDIwMjUgYXQgOTo0
NeKAr0FNIEFuZHJleSBHcm9kem92c2t5DQo+Pj4gPGFuZHJleS5ncm9kem92c2t5QGNyb3dk
c3RyaWtlLmNvbT4gd3JvdGU6DQo+Pj4+IE9uIDEwLzIwLzI1IDEyOjAzLCBTb25nIExpdSB3
cm90ZToNCj4+Pj4+IE9uIE1vbiwgT2N0IDIwLCAyMDI1IGF0IDc6NTbigK9BTSBBbmRyZXkg
R3JvZHpvdnNreQ0KPj4+Pj4gPGFuZHJleS5ncm9kem92c2t5QGNyb3dkc3RyaWtlLmNvbT4g
d3JvdGU6DQo+Pj4+PiBbLi4uXQ0KPj4+Pj4+PiBJZiB5b3UgYnVpbGQgdGhlIGtlcm5lbCBm
cm9tIHNvdXJjZSBjb2RlLCB0aGVyZSBhcmUgc29tZSBzYW1wbGVzIGluDQo+Pj4+Pj4+IHNh
bXBsZXMvbGl2ZXBhdGNoIHRoYXQgeW91IGNhbiB1c2UgZm9yIHRlc3RpbmcuIFBTOiBZb3Ug
bmVlZCB0byANCj4+Pj4+Pj4gZW5hYmxlDQo+Pj4+Pj4+DQo+Pj4+Pj4+IMKgwqDCoMKgIENP
TkZJR19TQU1QTEVfTElWRVBBVENIPW0NCj4+Pj4+Pj4NCj4+Pj4+Pj4gSSBob3BlIHRoaXMg
aGVscHMuDQo+Pj4+Pj4gVGhhbmtzIFNvbmcsIHdvcmtpbmcgb24gcmVwcm8sIGtlcm5lbCBy
ZWJ1aWx0LCB0ZXN0IG1vZHVsZSBpcyANCj4+Pj4+PiBsb2FkaW5nDQo+Pj4+Pj4gYnV0LCBi
cGZ0cmFjZSBpcyByZWZ1c2luZyB0byBhdHRhY2ggbm93IHRvIGZlbnRyaWVzL2ZleGl0cyAN
Cj4+Pj4+PiBjbGFpbWluZyB0aGUNCj4+Pj4+PiBjb3N0dW0ga2VybmVsIGlzIG5vdCBzdXBw
b3J0aW5nIGl0LiBJdCBkaWQNCj4+Pj4+PiBhdHRhY2ggaW4gdGhlIGNhc2Ugb2Ygc3RvY2sg
QVdTIGtlcm5lbCBpIGNvcGllZCB0aGUgLmNvbmZpZyBmcm9tLiBTbw0KPj4+Pj4+IGp1c3Qg
dHJ5aW5nIHRvIGZpZ3VyZSBvdXQgbm93IGlmIHNvbWUgS2NvZm5pZyBmbGFncyBhcmUgbWlz
c2luZyBvcg0KPj4+Pj4+IGRpZmZlcmVudCAuIExldCBtZSBrbm93IGluIGNhc2UgeW91IG1h
bmFnZSB0byBjb25maXJtIHlvdXJzZWxmIGluIA0KPj4+Pj4+IHRoZQ0KPj4+Pj4+IG1lYW53
aGlsZSB0aGUgZml4IHdvcmtzIGZvcg0KPj4+Pj4+IHlvdS4NCj4+Pj4+IFllcywgaXQgd29y
a2VkIGluIG15IHRlc3RzLg0KPj4+Pj4NCj4+Pj4+IFtyb290QChub25lKSAvXSMga3BhdGNo
IGxvYWQgDQo+Pj4+PiBsaW51eC9zYW1wbGVzL2xpdmVwYXRjaC9saXZlcGF0Y2gtc2FtcGxl
LmtvDQo+Pj4+PiBsb2FkaW5nIHBhdGNoIG1vZHVsZTogbGludXgvc2FtcGxlcy9saXZlcGF0
Y2gvbGl2ZXBhdGNoLXNhbXBsZS5rbw0KPj4+Pj4gW3Jvb3RAKG5vbmUpIC9dIyBicGZ0cmFj
ZS5yZWFsIC1lICdmZXhpdDpjbWRsaW5lX3Byb2Nfc2hvdw0KPj4+Pj4ge3ByaW50ZigiZmV4
aXRcbiIpO30nICYNCj4+Pj4+IFsxXSAzODgNCj4+Pj4+IFtyb290QChub25lKSAvXSMgQXR0
YWNoZWQgMSBwcm9iZQ0KPj4+Pj4gW3Jvb3RAKG5vbmUpIC9dIyBicGZ0cmFjZS5yZWFsIC1l
ICdmZW50cnk6Y21kbGluZV9wcm9jX3Nob3cNCj4+Pj4+IHtwcmludGYoImZlbnRyeVxuIik7
fScgJg0KPj4+Pj4gWzJdIDM5Nw0KPj4+Pj4gW3Jvb3RAKG5vbmUpIC9dIyBBdHRhY2hlZCAx
IHByb2JlDQo+Pj4+Pg0KPj4+Pj4gW3Jvb3RAKG5vbmUpIC9dIyBjYXQgL3Byb2MvY21kbGlu
ZQ0KPj4+Pj4gdGhpcyBoYXMgYmVlbiBsaXZlIHBhdGNoZWQNCj4+Pj4+IGZlbnRyeQ0KPj4+
Pj4gZmV4aXQNCj4+Pj4+DQo+Pj4+PiBUaGFua3MsDQo+Pj4+PiBTb25nDQo+Pj4+Pg0KPj4+
PiBWZXJpZmllZCB0aGUgZmFpbHVyZXMgSSBvYnNlcnZlIHdoZW4gdHJ5aW5nIHRvIGF0dGFj
aCB3aXRoIEJQRiANCj4+Pj4gdHJhY2UgYXJlDQo+Pj4+IG9ubHkgaW4gcHJlc2VuY2Ugb2Yg
cGF0Y2ggeW91IHByb3ZpZGVkLg0KPj4+PiBQbGVhc2Ugc2VlIGF0dGFjaGVkIGRtZXNnIGZv
ciBmYWlsdXJlcy4gSW5pdGlhbCB3YXJuaW5nIG9uIGJvb3QuDQo+Pj4+IFN1YnNlcXVlYnQg
d2FybmluZ3MgYW5kIGVycm9ycyBhdCB0aGUgcG9pbnQgaSB0cnkgdG8gcnVuDQo+Pj4+IHN1
ZG8gYnBmdHJhY2UgLWUgImZleGl0OmNtZGxpbmVfcHJvY19zaG93IHsgcHJpbnRmKFwiZmV4
aXQgaGl0XFxuXCIpOw0KPj4+PiBleGl0KCk7IH0iDQo+Pj4+DQo+Pj4+IHN1ZG86IHVuYWJs
ZSB0byByZXNvbHZlIGhvc3QgaXAtMTAtMTAtMTE1LTIzODogVGVtcG9yYXJ5IGZhaWx1cmUg
aW4gDQo+Pj4+IG5hbWUNCj4+Pj4gcmVzb2x1dGlvbg0KPj4+PiBzdGRpbjoxOjEtMjU6IEVS
Uk9SOiBrZnVuYy9rcmV0ZnVuYyBub3QgYXZhaWxhYmxlIGZvciB5b3VyIGtlcm5lbCANCj4+
Pj4gdmVyc2lvbi4NCj4+Pj4NCj4+Pj4gdWJ1bnR1QGlwLTEwLTEwLTExNS0yMzg6fi9saW51
eC02LjguMSQgc3VkbyBjYXQNCj4+Pj4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9hdmFp
bGFibGVfZmlsdGVyX2Z1bmN0aW9ucyB8IGdyZXANCj4+Pj4gY21kbGluZV9wcm9jX3Nob3cN
Cj4+Pj4gc3VkbzogdW5hYmxlIHRvIHJlc29sdmUgaG9zdCBpcC0xMC0xMC0xMTUtMjM4OiBU
ZW1wb3JhcnkgZmFpbHVyZSBpbiANCj4+Pj4gbmFtZQ0KPj4+PiByZXNvbHV0aW9uDQo+Pj4+
IGNhdDogL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9hdmFpbGFibGVfZmlsdGVyX2Z1bmN0
aW9uczogTm8gc3VjaCANCj4+Pj4gZGV2aWNlDQo+Pj4+DQo+Pj4+IEFmdGVyIHJlYm9vdCBh
bmQgYmVmb3JlIHRyeWluZyB0byBhdHRhY2cgd2l0aCBicGZ0cmFjZSwNCj4+Pj4gL3N5cy9r
ZXJuZWwvZGVidWcvdHJhY2luZy9hdmFpbGFibGVfZmlsdGVyX2Z1bmN0aW9ucyBpcyBhdmFp
bGFibGUgYW5kDQo+Pj4+IHNob3dzIGFsbCBmdW5jdGlvbi4NCj4+Pj4NCj4+Pj4gVXNpbmcg
c3RhYmxlIGtlcm5lbCBmcm9tDQo+Pj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19o
dHRwczovL2Nkbi5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwvdjYueC9saW51eC02Ljgu
MS50YXIuZ3pfXzshIUJtZHpTM19sVjlIZEtHOCExWkplNGpZNDlfeEl6cDRoNGk0QWJxcGtM
S29BcXJYTEZYMndEeGhvU1VEZzJrU2VUankzQ095OU1uZ05EUmxaaEoxb1VLZ2YxeVBxbW5U
WTktWTUwVGtBJCANCj4+Pj4gZm9yIGJ1aWxkLg0KPj4+PiBGVFJBQ0UgcmVsYXRlZCBLQ09O
RklHcyBiZWxsb3cNCj4+PiBJIGNhbiBzZWUgdGhlIHNpbWlsYXIgaXNzdWUgd2l0aCB0aGUg
dXBzdHJlYW0ga2VybmVsLiBJIHdhcyB0ZXN0aW5nIG9uDQo+Pj4gc3RhYmxlIDYuMTcgYmVm
b3JlIGp1c3Qga25vdyBiZWNhdXNlIG9mIGFub3RoZXIgaXNzdWUgd2l0aCB1cHN0cmVhbQ0K
Pj4+IGtlcm5lbCwgYW5kIHNvbWVob3cgNi4xNyBrZXJuZWwgZG9lc24ndCBzZWVtIHRvIGhh
dmUgdGhlIGlzc3VlLg0KPj4+DQo+Pj4gVG8gZml4IHRoaXMsIEkgdGhpbmsgd2Ugc2hvdWxk
IGxhbmQgYSBmaXggc2ltaWxhciB0byB0aGUgZWFybGllciBkaWZmOg0KPj4+DQo+Pj4gZGlm
ZiAtLWdpdCBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYyB3L2tlcm5lbC90cmFjZS9mdHJhY2Uu
Yw0KPj4+IGluZGV4IDQyYmQyYmE2OGE4Mi4uOGYzMjBkZjBhYzUyIDEwMDY0NA0KPj4+IC0t
LSBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4+ICsrKyB3L2tlcm5lbC90cmFjZS9mdHJh
Y2UuYw0KPj4+IEBAIC02MDQ5LDYgKzYwNDksOSBAQCBpbnQgcmVnaXN0ZXJfZnRyYWNlX2Rp
cmVjdChzdHJ1Y3QgZnRyYWNlX29wcw0KPj4+ICpvcHMsIHVuc2lnbmVkIGxvbmcgYWRkcikN
Cj4+Pg0KPj4+IMKgwqDCoMKgwqDCoMKgwqAgZXJyID0gcmVnaXN0ZXJfZnRyYWNlX2Z1bmN0
aW9uX25vbG9jayhvcHMpOw0KPj4+DQo+Pj4gK8KgwqDCoMKgwqDCoCBpZiAoZXJyKQ0KPj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlbW92ZV9kaXJlY3RfZnVuY3Rpb25z
X2hhc2goaGFzaCwgYWRkcik7DQo+Pj4gKw0KPj4+IMKgwqAgb3V0X3VubG9jazoNCj4+PiDC
oMKgwqDCoMKgwqDCoMKgIG11dGV4X3VubG9jaygmZGlyZWN0X211dGV4KTsNCj4+Pg0KPj4+
DQo+Pj4gU3RldmVuLA0KPj4+DQo+Pj4gRG9lcyB0aGlzIGNoYW5nZSBsb29rIGdvb2QgdG8g
eW91Pw0KPj4+DQo+Pj4NCj4+DQo+PiBTZWVtcyByZWFzb25hYmxlIHRvIG1lLCB3ZSBhcmUg
c2ltcGx5IGNsZWFuaW5nIHRoZSBlbnRyeSBvbiBmYWlsdXJlIA0KPj4gc28gd2UgZG9uJ3Qg
ZW5jb3VudGVyIGl0IGxhdGUgYW55bW9yZS4NCj4+IFNvIEkgd2lsbCBhcHBseSB0aGlzIHBh
dGNoIE9OTFkgYW5kIHJldGVzdCAtIGNvcnJlY3QgPw0KPj4NCj4+IEFub3RoZXIgcXVlc3Rp
b24gLSBpdCBzZWVtcyB5b3UgZm91bmQgd2hlcmUgaXQgYnJva2UgPyBJIHNhdyAnQ2M6IA0K
Pj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY2LjYrJyBpbiB5b3VyIHByZXYuIHBhdGNo
LicNCj4+IElmIHNvICwgY2FuIHlvdSBwbGVhc2UgcG9pbnQgbWUgdG8gdGhlIG9mZmVuZGlu
ZyBwYXRjaCBzbyBJIGFkZCB0aGlzIA0KPj4gdG8gbXkgcmVjb3JkcyBvZiBteSBkaXNjb3Zl
cnkgd29yayBvZiBicGYgY29leGlzdGVuY2UNCj4+IGxpdmVwYXRjaGluZyA/DQo+Pg0KPj4g
VGhhbmtzLA0KPj4NCj4+IEFuZHJleQ0KPg0KPg0KPiBVcGRhdGUgLSB3aXRoIGxhdGVzdCBm
aXggd29yayBmaW5kLCBib3RoIGFmdGVyIGxvYWRpbmcgdGhlIGxpdmVwYXRjaCANCj4gLmtv
wqAgbm8gY29uZmxpY3RzIGFuZCBob29rcyB3b3JrIGFuZCwNCj4gYmVmb3JlIGxvYWRpbmcg
aXQsIHByZSBleHNpc3RpbmcgaG9va3Mga2VlcCB3b3JraW5nIGFmdGVyIHRoZSBwYXRjaCBp
cyANCj4gbG9hZGVkDQo+DQo+IFlvdSBjYW4gYWRkIEFja2VkLWFuZC10ZXN0ZWQtYnk6IEFu
ZHJleSBHcm9kem92c2t5IA0KPiA8YW5kcmV5Lmdyb2R6b3Zza3lAY3Jvd2RzdHJpa2UuY29t
Pg0KPg0KPiBPbmNlIGFnYWluLCBpbiBjYXNlIHlvdSBub3cgdGhlIGV4YWN0IGNvbW1pdCB0
aGF0IGJyb2tlIGl0LCBwbGVhc2UgbGV0IA0KPiBtZSBrbm93Lg0KPg0KPiBUaGFua3MsDQo+
IEFuZHJleQ0KDQoNClNvbmcsIEkgaWRlbnRpZmllZCBhbm90aGVyIGlzc3VlIGluIHByZSA2
LjYga2VybmVsLCBidWlsZGluZyANCn4vbGludXgtNi41L3NhbXBsZXMvbGl2ZXBhdGNoL2xp
dmVwYXRjaC1zYW1wbGUuYyBhcyBrbywNCmJlZm9yZSBpbnNtb2RpbmcgaXQsIGJwZnRyYWNl
IGZlbnRyeS9mZXhpdCBmaXJlcyBhcyBleHBlY3RlZCwgYWZ0ZXIgDQppbnNtb2QsIHdoaWxl
IG5vIGVycm9ycyByZXBvcnRlZCBvbiBhdHRhY2htZW50cywNCnRoZSBob29rcyBzdG9wIGZp
cmluZywgYm90aCBpZiBhdHRhY2hpbmcgYmVmb3JlIGluc21vZCBhbmQgaWYgYXR0YWNoaW5n
IA0KYWZ0ZXIgaW5zbW9kLiBJZiBpIHJybW9kIHRoZSBrbywgZXhpc3RpbmcgaG9va3MNCnJl
c3VtZSB3b3JraW5nLg0KDQp1YnVudHVAaXAtMTAtMTAtMTE1LTIzODp+JCBjYXQgL3Byb2Mv
dmVyc2lvbl9zaWduYXR1cmUNClVidW50dSA2LjUuMC0xMDA4LjgtYXdzIDYuNS4zDQpTb3Vy
Y2Ugb2J0YWluZWQgdG8gYnVpbGQgdGhlIHRlc3QgbW9kdWxlIGZvciB0aGUgQVdTIGtlcm5l
bCBmcm9tIHRoZSANCnJlbGF0ZWQgc3RhYmxlIGJyYW5jaCAtIA0KaHR0cHM6Ly9jZG4ua2Vy
bmVsLm9yZy9wdWIvbGludXgva2VybmVsL3Y2LngvbGludXgtNi41LnRhci54eg0KDQpMZXQg
bWUga25vdyB3aGF0IHlvdSB0aGluay4NCg0KVGhhbmtzLA0KQW5kcmV5DQoNCg0KDQo+DQo+
Pg0KPj4+DQo+Pj4gVGhhbmtzLA0KPj4+IFNvbmcNCj4+DQo+Pg0KPg0KDQo=

