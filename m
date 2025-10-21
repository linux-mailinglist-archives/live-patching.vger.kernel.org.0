Return-Path: <live-patching+bounces-1784-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B3BBF701D
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 16:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0EB64FA391
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 14:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BF6259CB3;
	Tue, 21 Oct 2025 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="A3GWloYo"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00206402.pphosted.com (mx0a-00206402.pphosted.com [148.163.148.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958B28F6F
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.148.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056163; cv=none; b=YEsvEL+zEXy6aZprYttT09bidXD7iJGzo6qwVWAm+I5eH46+aqAJHyR+DdG5qwqR6HOSkEm+ZPrCUoK9a9anMUSZWs2kVdiGYgsmmLkQvbhVQ574+oVGAHz97V4aDKJqOsRmSXClBiSIXHAfEeg9+5Gun/R9Sud4TaGV4rMU21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056163; c=relaxed/simple;
	bh=gn3wqAGxxYifYABqaQOFPovcHw2GOzjYBUPjfFEauH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FLmULIlQ5HYvB0419w25R56I9m66/Sk0QNM0jJ8wkcfHlz3vtgvXkVZzhSWUU06E+R8ci8LRJtRFU+2lHfGxKmsqmEqc85wEGz6FvylNBlkdYYSJ6zMUGPGnMUnxPiHTCBix5C7LOL3nRQMyf/5a0G/n7edMyddYbLooHYWh3eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=A3GWloYo; arc=none smtp.client-ip=148.163.148.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354651.ppops.net [127.0.0.1])
	by mx0a-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LCrGH7022949;
	Tue, 21 Oct 2025 14:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=gn3wqAGxxYifYABqaQOFPovcHw2GOzjYBUPjfFEauH8=; b=A3GW
	loYoVwRxxqUx+vZiQbcOSm4NvZssBxyZ3g4Nw+V5RsDRFGmoRGF0883oojC+DXGu
	m6FA5VzGC3kEbsBxKYRpJRb7o2TRLQVUDlm2QPlAvca2Oc2I9JXYiniy1D4l9CMv
	ZhyHeWvzKB59CHSBsiiMN+ggQ4ZmTxVtejLfuySIY66nFNQ8soNhVEFKjN72kFkw
	IHQsIvWphywHktZNAbbK0DxkzPYilbM3kl7C0OiftEzexZtn2XCHtVzHwtx5EqYr
	v6LU9q40sPoL4UcTL2d5vu8aht1qkNmojg5C9ZPyXVz2dA9Sb28FCNEkB0/WyOso
	WoUzoIQLwT+JeOonEw==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0a-00206402.pphosted.com (PPS) with ESMTPS id 49vp4xeusv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 14:15:53 +0000 (GMT)
Received: from [10.82.59.75] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 14:15:51 +0000
Message-ID: <c3ad390e-4320-46bb-bc72-b57ab628bff6@crowdstrike.com>
Date: Tue, 21 Oct 2025 10:15:50 -0400
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
 <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com>
 <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH008.crowdstrike.sys (10.100.11.75) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Proofpoint-GUID: TufdZga2kTadOcWRu_0hqj1XxY_lTrQl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDAwNyBTYWx0ZWRfX5EcpYjIzypQH
 Jw+Z5M4GyrtJWvHEOeDWUCtlf3IPozNzMQkflfU6nmniaDfT9EP1FtdJEO8WMxVvMHdLkqEKg8v
 XHaX74JLjfihc8Gniob0xP+M4O5q0Zm0dITBEXqHtsciOCwOZ7k3epMeE671WBzicVez+PLd3ix
 Qj0DjbLcZvLzCMUaLhIS7WBpNruPB3p81uoOIY+OANZahp464Nmrhk0GqFaA4IIa2EeUWxNlBoK
 VrN+0HBDABRGEUaNfNhVPIa+J5ZgoHTq07t5ahIyvK6tDxN58ZhXncLBNVTVWdfbHVGTd1F5ztR
 K56lLFJmzpaw0gznti99SP3rq7fUCFK8JMt17z6Z0i+HH2UA+fLo4kohi0WDvfSEUNxQE2m/O0g
 MQbjG/Zov3l7GXJhZRBK0f7mcEn8DA==
X-Proofpoint-ORIG-GUID: TufdZga2kTadOcWRu_0hqj1XxY_lTrQl
X-Authority-Analysis: v=2.4 cv=Jf2xbEKV c=1 sm=1 tr=0 ts=68f79599 cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8 a=cm27Pg_UAAAA:8
 a=iox4zFpeAAAA:8 a=rwYTVIPPPP4nPUPr2ngA:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11589
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510190007

T24gMTAvMjEvMjUgMDI6MDcsIFNvbmcgTGl1IHdyb3RlOg0KPiBPbiBNb24sIE9jdCAyMCwg
MjAyNSBhdCAyOjMx4oCvUE0gQW5kcmV5IEdyb2R6b3Zza3kNCj4gPGFuZHJleS5ncm9kem92
c2t5QGNyb3dkc3RyaWtlLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+PiBTb25nLCBJIGlkZW50
aWZpZWQgYW5vdGhlciBpc3N1ZSBpbiBwcmUgNi42IGtlcm5lbCwgYnVpbGRpbmcNCj4+IH4v
bGludXgtNi41L3NhbXBsZXMvbGl2ZXBhdGNoL2xpdmVwYXRjaC1zYW1wbGUuYyBhcyBrbywN
Cj4+IGJlZm9yZSBpbnNtb2RpbmcgaXQsIGJwZnRyYWNlIGZlbnRyeS9mZXhpdCBmaXJlcyBh
cyBleHBlY3RlZCwgYWZ0ZXINCj4+IGluc21vZCwgd2hpbGUgbm8gZXJyb3JzIHJlcG9ydGVk
IG9uIGF0dGFjaG1lbnRzLA0KPj4gdGhlIGhvb2tzIHN0b3AgZmlyaW5nLCBib3RoIGlmIGF0
dGFjaGluZyBiZWZvcmUgaW5zbW9kIGFuZCBpZiBhdHRhY2hpbmcNCj4+IGFmdGVyIGluc21v
ZC4gSWYgaSBycm1vZCB0aGUga28sIGV4aXN0aW5nIGhvb2tzDQo+PiByZXN1bWUgd29ya2lu
Zy4NCj4+DQo+PiB1YnVudHVAaXAtMTAtMTAtMTE1LTIzODp+JCBjYXQgL3Byb2MvdmVyc2lv
bl9zaWduYXR1cmUNCj4+IFVidW50dSA2LjUuMC0xMDA4LjgtYXdzIDYuNS4zDQo+PiBTb3Vy
Y2Ugb2J0YWluZWQgdG8gYnVpbGQgdGhlIHRlc3QgbW9kdWxlIGZvciB0aGUgQVdTIGtlcm5l
bCBmcm9tIHRoZQ0KPj4gcmVsYXRlZCBzdGFibGUgYnJhbmNoIC0NCj4+IGh0dHBzOi8vdXJs
ZGVmZW5zZS5jb20vdjMvX19odHRwczovL2Nkbi5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJu
ZWwvdjYueC9saW51eC02LjUudGFyLnh6X187ISFCbWR6UzNfbFY5SGRLRzgheExtQ2I3UEN3
Q2o3dk04SmpLeF9uN1pVVmpXME9qOEloOVQzWXFVNEktSm9HeTdldlRzYzdVMTdlbXQzbm5E
bWRYZGNoWHhjS0hpXzZtVkJ0NVFiS3pqMiQNCj4+DQo+PiBMZXQgbWUga25vdyB3aGF0IHlv
dSB0aGluay4NCj4gSSB0ZXN0ZWQgdmFyaW91cyBzdGFibGUga2VybmVscy4gSSBnb3Q6DQo+
DQo+IFdpdGggbGl2ZXBhdGNoLCBmZW50cnkgYW5kIGZleGl0IHdvcmsgb24gNi4zIGtlcm5l
bHMuDQo+DQo+IE9uIDYuNCBhbmQgNi41IGtlcm5lbHMsIHRoZSBjb21iaW5hdGlvbiBzdG9w
cyB3b3JraW5nIHNpbmNlIHRoaXMgY29tbWl0Og0KPg0KPiBjb21taXQgNjBjODk3MTg5OWYz
YjM0YWQyNDg1NzkxM2MwNzg0ZGFiMDg5NjJmMA0KPiBBdXRob3I6IEZsb3JlbnQgUmV2ZXN0
IDxyZXZlc3RAY2hyb21pdW0ub3JnPg0KPiBEYXRlOiAgIDIgeWVhcnMsIDcgbW9udGhzIGFn
bw0KPg0KPiAgICAgIGZ0cmFjZTogTWFrZSBESVJFQ1RfQ0FMTFMgd29yayBXSVRIX0FSR1Mg
YW5kICFXSVRIX1JFR1MNCj4NCj4NCj4gT24gNi41IGtlcm5lbHMsIGl0IGdvdCBmaXhlZCBi
eSB0aGUgZm9sbG93aW5nIHR3byBjb21taXRzOg0KPg0KPiBjb21taXQgYThiOWNmNjJhZGUx
YmYxNzI2MWE5NzlmYzk3ZTQwYzJkNzg0MjM1Mw0KPiBBdXRob3I6IE1hc2FtaSBIaXJhbWF0
c3UgKEdvb2dsZSkgPG1oaXJhbWF0QGtlcm5lbC5vcmc+DQo+IERhdGU6IDEgeWVhciwgOSBt
b250aHMgYWdvDQo+IGZ0cmFjZTogRml4IERJUkVDVF9DQUxMUyB0byB1c2UgU0FWRV9SRUdT
IGJ5IGRlZmF1bHQNCj4NCj4gY29tbWl0IGJkYmRkYjEwOWM3NTM2NWQyMmVjNDgyNmY0ODBj
NWU3NTg2OWUxY2INCj4gQXV0aG9yOiBQZXRyIFBhdmx1IDxwZXRyLnBhdmx1QHN1c2UuY29t
Pg0KPiBEYXRlOiAgIDEgeWVhciwgOCBtb250aHMgYWdvDQo+DQo+ICAgICAgdHJhY2luZzog
Rml4IEhBVkVfRFlOQU1JQ19GVFJBQ0VfV0lUSF9SRUdTIGlmZGVmDQo+DQo+IEkgdHJpZWQg
dG8gY2hlcnJ5LXBpY2sgNjBjODk3MTg5OWYzYjM0YWQyNDg1NzkxM2MwNzg0ZGFiMDg5NjJm
MA0KPiBhbmQgYThiOWNmNjJhZGUxYmYxNzI2MWE5NzlmYzk3ZTQwYzJkNzg0MjM1Mywgb24g
dG9wIG9mIDYuNS4xMw0KPiBrZXJuZWwuIFRoZW4sIGZlbnRyeSBhbmQgZmV4aXQgYm90aCB3
b3JrIHdpdGggbGl2ZXBhdGNoLg0KDQoNCkkgc2VlLCB0aGFua3MgZm9yIHRlc3RpbmchIElz
IHRoZSByZWFzb24gaXQgYnJlYWtzIHNvIG9mdGVuIGlzIGJlY2F1c2UgDQp0aGlzIGNvbWJp
bmF0aW9uIG9mIGhhdmluZyBCUEYNCmFuZCBsbGl2ZXBhdGNoIHRvZ2V0aGVyIG9uIGEgc3lz
dGVtIHdpdGggaW50ZXJzZWN0aW9uIG9uIHNhbWUgZnVuY3Rpb25zIA0KYXMgcmVsYXRpdmVs
ecKgIMKgcmF0ZSBldmVudCBhbmQNCnNvIHJlZ3Jlc3Npb25zIGdvIGVhc2lseSB1bm5vdGlj
ZWQgPyBJc24ndCB0aGVyZSBhbnkgcmVsZXZhbnQgYXV0b21hdGVkIA0KdGVzdGluZyBpbiB1
cHN0cmVhbSB0aGF0IGNoZWNrcyBmb3INCnRob3NlIHR5cGVzIG9mIGJyZWFrcyA/DQoNClRo
YW5rcywNCkFuZHJleQ0KDQo+DQo+IFRoYW5rcywNCj4gU29uZw0KDQoNCg==

