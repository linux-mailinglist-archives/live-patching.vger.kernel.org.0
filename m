Return-Path: <live-patching+bounces-1774-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 115DFBF31E0
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 21:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E4E674E0554
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 19:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE5A2D0600;
	Mon, 20 Oct 2025 19:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="necSOU7y"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00206402.pphosted.com (mx0a-00206402.pphosted.com [148.163.148.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1872D063A
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 19:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.148.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760987431; cv=none; b=MzHdnO2/LHSxWwayQahyq3h3eGfvttOCP3v4xHWFVBP9MiQio1chy6kskgQ/+n+81PCHCINPynsTSUfresxzghoMU3Tn1sLksnvoIEXUx6kj9UZPITWHbML+yfZAdvPBXr6tqwke1kahmXmkH9P7heIxF+7JHuPYPq3+O2kEtC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760987431; c=relaxed/simple;
	bh=bfZrfmYqz6FG7WmM7XzdoHPjbOYjYwLTikkcKt/VBCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pdEtOHJS/oRpXokVQY59HA262yVqU3Fn/t3/NM9lTM21kFjNCSTObebyvsiG/yPj56/KDR0SLLTv5g+Uq1+a6+TW8bZimZ74fYN2gzrsuXI+5OA8PVGRYZZhqEj21yr7Y5qQ8aYwqUoCLRm4RyQyyDIEge0Fs38uOSMLH96MXn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=necSOU7y; arc=none smtp.client-ip=148.163.148.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354652.ppops.net [127.0.0.1])
	by mx0a-00206402.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KHbtxB013874;
	Mon, 20 Oct 2025 19:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=bfZrfmYqz6FG7WmM7XzdoHPjbOYjYwLTikkcKt/VBCU=; b=necS
	OU7yTFeoX0fZj5WeNCmQeunS7VN83bO+nrR8HUSt/s2sWWcO8PLsNF8kMVn/ZO1y
	UhlaNEefFq0O+F2A7qk1fEmq1Q881+hxGa1/HjXj1wZg/kOg3udEUjNK+1FqA83p
	6CAt71+sU+4L0WyGavInafsWmr1QkHIJsrT/eJ3b8qCv/3w1EmzLxpxEl0LZ1Gmz
	HPkKRxZ+It7SkK+TDfo5YpDxl45IjLpb8E5IIxvMuUUzaBEThDSog0+3up9HXu1O
	fvw9InECA+oQdV63Ny4Cnnny84Np32zDp7lP95e9bMQGPeO/v1zohKqyCf5yWMZ3
	a3SRSg3j49j1JyljRw==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0a-00206402.pphosted.com (PPS) with ESMTPS id 49vrq0c07b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 19:10:22 +0000 (GMT)
Received: from [10.82.61.83] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 20 Oct
 2025 19:10:20 +0000
Message-ID: <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
Date: Mon, 20 Oct 2025 15:10:19 -0400
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
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
 <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
 <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH008.crowdstrike.sys (10.100.11.75) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Proofpoint-GUID: j_F9IZNKDBsFzG0qNHe9P5Q5C9sui11V
X-Authority-Analysis: v=2.4 cv=ANhDx8K4 c=1 sm=1 tr=0 ts=68f6891e cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=wTsGqpD-R78rOsQO:21 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8
 a=EhQEAU09TRWmCAx_xsYA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDAyNiBTYWx0ZWRfX2FXO/li0yGdz
 2adB5svagzWa6cr+2D98bgtfEeXV0L1DTbiCl22y/KbMHJ6Vmi5/zOBCxGXY0JuW5tGQDR2DQGV
 ddxvF09io7oY/zqYAcrBczDy8UxdeFSyUIThJ+FYTA8clzr+QB/gDJ0xF8WMc4mEYCjIjC+GcL3
 2l08PAtTrNUnGTmVuYpPjtJ2trMH6E9qQnKtm1MjVp6MhvqbhqLeetr9gsN6CBIDWzA1gQs8wqR
 XUPhq2TZIZNOytieLdaBMPZq2YvgxiQdgy1PHff15hmxBtLLgjXSlQMPZrFKpqp2ab9Q87hl9W2
 n2QVk7dQqzYEEvHfZ+Gzp41kMfjzzGPtOkV2Sod3JpjuSyNFUox48A46oULprc9tBY4PljFQMpp
 IfVGag14vtk+gU4Ctjw5ndu9Pa8WuA==
X-Proofpoint-ORIG-GUID: j_F9IZNKDBsFzG0qNHe9P5Q5C9sui11V
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11588
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510190026

T24gMTAvMjAvMjUgMTQ6NTMsIFNvbmcgTGl1IHdyb3RlOg0KPiBPbiBNb24sIE9jdCAyMCwg
MjAyNSBhdCA5OjQ14oCvQU0gQW5kcmV5IEdyb2R6b3Zza3kNCj4gPGFuZHJleS5ncm9kem92
c2t5QGNyb3dkc3RyaWtlLmNvbT4gd3JvdGU6DQo+PiBPbiAxMC8yMC8yNSAxMjowMywgU29u
ZyBMaXUgd3JvdGU6DQo+Pj4gT24gTW9uLCBPY3QgMjAsIDIwMjUgYXQgNzo1NuKAr0FNIEFu
ZHJleSBHcm9kem92c2t5DQo+Pj4gPGFuZHJleS5ncm9kem92c2t5QGNyb3dkc3RyaWtlLmNv
bT4gd3JvdGU6DQo+Pj4gWy4uLl0NCj4+Pj4+IElmIHlvdSBidWlsZCB0aGUga2VybmVsIGZy
b20gc291cmNlIGNvZGUsIHRoZXJlIGFyZSBzb21lIHNhbXBsZXMgaW4NCj4+Pj4+IHNhbXBs
ZXMvbGl2ZXBhdGNoIHRoYXQgeW91IGNhbiB1c2UgZm9yIHRlc3RpbmcuIFBTOiBZb3UgbmVl
ZCB0byBlbmFibGUNCj4+Pj4+DQo+Pj4+PiAgICAgIENPTkZJR19TQU1QTEVfTElWRVBBVENI
PW0NCj4+Pj4+DQo+Pj4+PiBJIGhvcGUgdGhpcyBoZWxwcy4NCj4+Pj4gVGhhbmtzIFNvbmcs
IHdvcmtpbmcgb24gcmVwcm8sIGtlcm5lbCByZWJ1aWx0LCB0ZXN0IG1vZHVsZSBpcyBsb2Fk
aW5nDQo+Pj4+IGJ1dCwgYnBmdHJhY2UgaXMgcmVmdXNpbmcgdG8gYXR0YWNoIG5vdyB0byBm
ZW50cmllcy9mZXhpdHMgY2xhaW1pbmcgdGhlDQo+Pj4+IGNvc3R1bSBrZXJuZWwgaXMgbm90
IHN1cHBvcnRpbmcgaXQuIEl0IGRpZA0KPj4+PiBhdHRhY2ggaW4gdGhlIGNhc2Ugb2Ygc3Rv
Y2sgQVdTIGtlcm5lbCBpIGNvcGllZCB0aGUgLmNvbmZpZyBmcm9tLiBTbw0KPj4+PiBqdXN0
IHRyeWluZyB0byBmaWd1cmUgb3V0IG5vdyBpZiBzb21lIEtjb2ZuaWcgZmxhZ3MgYXJlIG1p
c3Npbmcgb3INCj4+Pj4gZGlmZmVyZW50IC4gTGV0IG1lIGtub3cgaW4gY2FzZSB5b3UgbWFu
YWdlIHRvIGNvbmZpcm0geW91cnNlbGYgaW4gdGhlDQo+Pj4+IG1lYW53aGlsZSB0aGUgZml4
IHdvcmtzIGZvcg0KPj4+PiB5b3UuDQo+Pj4gWWVzLCBpdCB3b3JrZWQgaW4gbXkgdGVzdHMu
DQo+Pj4NCj4+PiBbcm9vdEAobm9uZSkgL10jIGtwYXRjaCBsb2FkIGxpbnV4L3NhbXBsZXMv
bGl2ZXBhdGNoL2xpdmVwYXRjaC1zYW1wbGUua28NCj4+PiBsb2FkaW5nIHBhdGNoIG1vZHVs
ZTogbGludXgvc2FtcGxlcy9saXZlcGF0Y2gvbGl2ZXBhdGNoLXNhbXBsZS5rbw0KPj4+IFty
b290QChub25lKSAvXSMgYnBmdHJhY2UucmVhbCAtZSAnZmV4aXQ6Y21kbGluZV9wcm9jX3No
b3cNCj4+PiB7cHJpbnRmKCJmZXhpdFxuIik7fScgJg0KPj4+IFsxXSAzODgNCj4+PiBbcm9v
dEAobm9uZSkgL10jIEF0dGFjaGVkIDEgcHJvYmUNCj4+PiBbcm9vdEAobm9uZSkgL10jIGJw
ZnRyYWNlLnJlYWwgLWUgJ2ZlbnRyeTpjbWRsaW5lX3Byb2Nfc2hvdw0KPj4+IHtwcmludGYo
ImZlbnRyeVxuIik7fScgJg0KPj4+IFsyXSAzOTcNCj4+PiBbcm9vdEAobm9uZSkgL10jIEF0
dGFjaGVkIDEgcHJvYmUNCj4+Pg0KPj4+IFtyb290QChub25lKSAvXSMgY2F0IC9wcm9jL2Nt
ZGxpbmUNCj4+PiB0aGlzIGhhcyBiZWVuIGxpdmUgcGF0Y2hlZA0KPj4+IGZlbnRyeQ0KPj4+
IGZleGl0DQo+Pj4NCj4+PiBUaGFua3MsDQo+Pj4gU29uZw0KPj4+DQo+PiBWZXJpZmllZCB0
aGUgZmFpbHVyZXMgSSBvYnNlcnZlIHdoZW4gdHJ5aW5nIHRvIGF0dGFjaCB3aXRoIEJQRiB0
cmFjZSBhcmUNCj4+IG9ubHkgaW4gcHJlc2VuY2Ugb2YgcGF0Y2ggeW91IHByb3ZpZGVkLg0K
Pj4gUGxlYXNlIHNlZSBhdHRhY2hlZCBkbWVzZyBmb3IgZmFpbHVyZXMuIEluaXRpYWwgd2Fy
bmluZyBvbiBib290Lg0KPj4gU3Vic2VxdWVidCB3YXJuaW5ncyBhbmQgZXJyb3JzIGF0IHRo
ZSBwb2ludCBpIHRyeSB0byBydW4NCj4+IHN1ZG8gYnBmdHJhY2UgLWUgImZleGl0OmNtZGxp
bmVfcHJvY19zaG93IHsgcHJpbnRmKFwiZmV4aXQgaGl0XFxuXCIpOw0KPj4gZXhpdCgpOyB9
Ig0KPj4NCj4+IHN1ZG86IHVuYWJsZSB0byByZXNvbHZlIGhvc3QgaXAtMTAtMTAtMTE1LTIz
ODogVGVtcG9yYXJ5IGZhaWx1cmUgaW4gbmFtZQ0KPj4gcmVzb2x1dGlvbg0KPj4gc3RkaW46
MToxLTI1OiBFUlJPUjoga2Z1bmMva3JldGZ1bmMgbm90IGF2YWlsYWJsZSBmb3IgeW91ciBr
ZXJuZWwgdmVyc2lvbi4NCj4+DQo+PiB1YnVudHVAaXAtMTAtMTAtMTE1LTIzODp+L2xpbnV4
LTYuOC4xJCBzdWRvIGNhdA0KPj4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9hdmFpbGFi
bGVfZmlsdGVyX2Z1bmN0aW9ucyB8IGdyZXANCj4+IGNtZGxpbmVfcHJvY19zaG93DQo+PiBz
dWRvOiB1bmFibGUgdG8gcmVzb2x2ZSBob3N0IGlwLTEwLTEwLTExNS0yMzg6IFRlbXBvcmFy
eSBmYWlsdXJlIGluIG5hbWUNCj4+IHJlc29sdXRpb24NCj4+IGNhdDogL3N5cy9rZXJuZWwv
ZGVidWcvdHJhY2luZy9hdmFpbGFibGVfZmlsdGVyX2Z1bmN0aW9uczogTm8gc3VjaCBkZXZp
Y2UNCj4+DQo+PiBBZnRlciByZWJvb3QgYW5kIGJlZm9yZSB0cnlpbmcgdG8gYXR0YWNnIHdp
dGggYnBmdHJhY2UsDQo+PiAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2F2YWlsYWJsZV9m
aWx0ZXJfZnVuY3Rpb25zIGlzIGF2YWlsYWJsZSBhbmQNCj4+IHNob3dzIGFsbCBmdW5jdGlv
bi4NCj4+DQo+PiBVc2luZyBzdGFibGUga2VybmVsIGZyb20NCj4+IGh0dHBzOi8vdXJsZGVm
ZW5zZS5jb20vdjMvX19odHRwczovL2Nkbi5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwv
djYueC9saW51eC02LjguMS50YXIuZ3pfXzshIUJtZHpTM19sVjlIZEtHOCExWkplNGpZNDlf
eEl6cDRoNGk0QWJxcGtMS29BcXJYTEZYMndEeGhvU1VEZzJrU2VUankzQ095OU1uZ05EUmxa
aEoxb1VLZ2YxeVBxbW5UWTktWTUwVGtBJCAgZm9yIGJ1aWxkLg0KPj4gRlRSQUNFIHJlbGF0
ZWQgS0NPTkZJR3MgYmVsbG93DQo+IEkgY2FuIHNlZSB0aGUgc2ltaWxhciBpc3N1ZSB3aXRo
IHRoZSB1cHN0cmVhbSBrZXJuZWwuIEkgd2FzIHRlc3Rpbmcgb24NCj4gc3RhYmxlIDYuMTcg
YmVmb3JlIGp1c3Qga25vdyBiZWNhdXNlIG9mIGFub3RoZXIgaXNzdWUgd2l0aCB1cHN0cmVh
bQ0KPiBrZXJuZWwsIGFuZCBzb21laG93IDYuMTcga2VybmVsIGRvZXNuJ3Qgc2VlbSB0byBo
YXZlIHRoZSBpc3N1ZS4NCj4NCj4gVG8gZml4IHRoaXMsIEkgdGhpbmsgd2Ugc2hvdWxkIGxh
bmQgYSBmaXggc2ltaWxhciB0byB0aGUgZWFybGllciBkaWZmOg0KPg0KPiBkaWZmIC0tZ2l0
IGkva2VybmVsL3RyYWNlL2Z0cmFjZS5jIHcva2VybmVsL3RyYWNlL2Z0cmFjZS5jDQo+IGlu
ZGV4IDQyYmQyYmE2OGE4Mi4uOGYzMjBkZjBhYzUyIDEwMDY0NA0KPiAtLS0gaS9rZXJuZWwv
dHJhY2UvZnRyYWNlLmMNCj4gKysrIHcva2VybmVsL3RyYWNlL2Z0cmFjZS5jDQo+IEBAIC02
MDQ5LDYgKzYwNDksOSBAQCBpbnQgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdChzdHJ1Y3QgZnRy
YWNlX29wcw0KPiAqb3BzLCB1bnNpZ25lZCBsb25nIGFkZHIpDQo+DQo+ICAgICAgICAgIGVy
ciA9IHJlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbl9ub2xvY2sob3BzKTsNCj4NCj4gKyAgICAg
ICBpZiAoZXJyKQ0KPiArICAgICAgICAgICAgICAgcmVtb3ZlX2RpcmVjdF9mdW5jdGlvbnNf
aGFzaChoYXNoLCBhZGRyKTsNCj4gKw0KPiAgICBvdXRfdW5sb2NrOg0KPiAgICAgICAgICBt
dXRleF91bmxvY2soJmRpcmVjdF9tdXRleCk7DQo+DQo+DQo+IFN0ZXZlbiwNCj4NCj4gRG9l
cyB0aGlzIGNoYW5nZSBsb29rIGdvb2QgdG8geW91Pw0KPg0KPg0KDQpTZWVtcyByZWFzb25h
YmxlIHRvIG1lLCB3ZSBhcmUgc2ltcGx5IGNsZWFuaW5nIHRoZSBlbnRyeSBvbiBmYWlsdXJl
IHNvIA0Kd2UgZG9uJ3QgZW5jb3VudGVyIGl0IGxhdGUgYW55bW9yZS4NClNvIEkgd2lsbCBh
cHBseSB0aGlzIHBhdGNoIE9OTFkgYW5kIHJldGVzdCAtIGNvcnJlY3QgPw0KDQpBbm90aGVy
IHF1ZXN0aW9uIC0gaXQgc2VlbXMgeW91IGZvdW5kIHdoZXJlIGl0IGJyb2tlID8gSSBzYXcg
J0NjOiANCnN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2Ni42KycgaW4geW91ciBwcmV2LiBw
YXRjaC4nDQpJZiBzbyAsIGNhbiB5b3UgcGxlYXNlIHBvaW50IG1lIHRvIHRoZSBvZmZlbmRp
bmcgcGF0Y2ggc28gSSBhZGQgdGhpcyB0byANCm15IHJlY29yZHMgb2YgbXkgZGlzY292ZXJ5
IHdvcmsgb2YgYnBmIGNvZXhpc3RlbmNlDQpsaXZlcGF0Y2hpbmcgPw0KDQpUaGFua3MsDQoN
CkFuZHJleQ0KDQo+DQo+IFRoYW5rcywNCj4gU29uZw0KDQoNCg==

