Return-Path: <live-patching+bounces-1880-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DB9C82C10
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 23:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 623933AD735
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 22:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2DA26F46E;
	Mon, 24 Nov 2025 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="RhkuS5Cq"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00206402.pphosted.com (mx0a-00206402.pphosted.com [148.163.148.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6B32749DC;
	Mon, 24 Nov 2025 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.148.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024876; cv=none; b=WGUSrb2nCCNfy/5SaZ7MX9jOtYw/hKE0OlSuxquKk0qIuySeiVXQwl4t961VQVOoWgijt3JHrdvSAFVd2vX/tki7CkISUZ0ANOQy01lg19H9lIEUAcre8lGgK1qK+QIEM6xb70VDauSM7izYB3LdBgG7Tvw1R/H8Rwqs6NpFaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024876; c=relaxed/simple;
	bh=jP/pGyOdjRV387IfnKeBrXCc4Iw5gt5AHPifuno0qRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MUtaoHsFhvM+mRckK6wwfDjr+0dnKqb9IUiyeEKJkB+lX6J7ip/+qLSBKn4JZLSmHrWVj5y3Y6F01xZ+Kvhof/YOYZfC/E6KSxLTv0m+doCyC0yuVzicMdtoiCgeCuIS0TRHadr8BxGbmijC3MWqnY57J9LmFPIeXK4wrSlVH0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=RhkuS5Cq; arc=none smtp.client-ip=148.163.148.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354650.ppops.net [127.0.0.1])
	by mx0a-00206402.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOL7idw2444603;
	Mon, 24 Nov 2025 22:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=jP/pGyOdjRV387IfnKeBrXCc4Iw5gt5AHPifuno0qRM=; b=Rhku
	S5CqnfgjRG0GVZcvvUPmGHsWtdJk7oU3/rcYHS4t2wqDmfIsrFhAP4q041KXeHJM
	Pak6Q7ADUi8lk/t4U2m54uf/WMdJbGOYaoXrfA0SiF6TwFl5Zu3OJ0jNegQUXOAO
	zEsA+9KCbQEck8+YjCpqm3ZqEYHMy6sPYPy67676ICRHxngrelnlGRLPx5z7fK7p
	gR886MGRtj+B0Lb5CGxAmabvKE4eTe/WJOm8hsLc0TboBId9dYhNglo46BDq8Vyv
	goQDPGDwuGN1afVrwSgO5jOPUwo63NGpLMjRl3GFq7eTzXABmmNAJTPcuXHHWx+a
	GsoNaXqy2lHUktW5KA==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0a-00206402.pphosted.com (PPS) with ESMTPS id 4amy0prdgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 22:54:17 +0000 (GMT)
Received: from [10.82.59.75] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 24 Nov
 2025 22:54:16 +0000
Message-ID: <30ddcf30-f176-48f5-b00f-967f5409243f@crowdstrike.com>
Date: Mon, 24 Nov 2025 17:54:15 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: BPF fentry/fexit trampolines stall livepatch
 stalls transition due to missing ORC unwind metadata
To: Josh Poimboeuf <jpoimboe@kernel.org>
CC: Miroslav Benes <mbenes@suse.cz>, <bpf@vger.kernel.org>,
        <live-patching@vger.kernel.org>,
        DL Linux Open Source Team
	<linux-open-source@crowdstrike.com>,
        Petr Mladek <pmladek@suse.com>, Song Liu
	<song@kernel.org>,
        <andrii@kernel.org>, Raja Khan <raja.khan@crowdstrike.com>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
 <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
 <d7b75cdc-a872-4425-a5f6-d41b1982cca7@crowdstrike.com>
 <3irfgmzksrfchngic6eowdu7ii5a5axrx5ofgneqastd4cjkpk@xrhabkis5z2k>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <3irfgmzksrfchngic6eowdu7ii5a5axrx5ofgneqastd4cjkpk@xrhabkis5z2k>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH014.crowdstrike.sys (10.100.11.87) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Authority-Analysis: v=2.4 cv=NfrrFmD4 c=1 sm=1 tr=0 ts=6924e219 cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Nd_IPnJdYLefbO55YtcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE5OCBTYWx0ZWRfXxHo2eAiyxJ9W
 CBm/THRRftS3DK/FsWvFaR6Onb1YlA9p4OARAYTJuZeA9mnFYSP/GdSjchGtgz2ckga+RjBZGcw
 PFfOh7MsgcOUIUN+wtRcPaZa2rPi/38GS6zRZTr1E4UuRyYAKa9LbP5gskum/7B0BNrDHlF11wW
 VkGN5NR8LKPWttIhp4KMo34VxhydnpjKGV8A2EakygElHcVgrRM8CP1jZtZMs/tR56hATLOojM/
 TGlPBv+/Al/7ob+/ZNqgJS2+4sUy9tmx5GiZLsbC91MgiCzJ7N/3Ul2EFJJACyWEja9mRBT0DSp
 BApTQi1xgfhlUn3Tftkl2joY938siENcJs4KKb49H+nAEhxOfGzbu5Ty4r/FZkGiu6xAymXYGbz
 u/iyG+pPdWibU4Hmne+ewKJ+5QU/Uw==
X-Proofpoint-GUID: ztKrds3FdHT3kr3NlKchyJ7KC9-23znt
X-Proofpoint-ORIG-GUID: ztKrds3FdHT3kr3NlKchyJ7KC9-23znt
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11623
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511240198

T24gMTEvMjQvMjUgMTc6NTEsIEpvc2ggUG9pbWJvZXVmIHdyb3RlOg0KPiBPbiBNb24sIE5v
diAyNCwgMjAyNSBhdCAwNTowNjowNFBNIC0wNTAwLCBBbmRyZXkgR3JvZHpvdnNreSB3cm90
ZToNCj4+PiBBbmRyZXksIGNhbiB5b3UgdHJ5IHRoaXMgcGF0Y2g/DQo+Pg0KPj4gSGV5IEpv
c2gsIHRoYW5rIHlvdSBmb3IgbG9va2luZywgY2FuIHlvdSBwbGVhc2UgYWR2aXNlIHRoZSBz
dGFibGUNCj4+IGtlcm5lbCB2ZXJzaW9uIHlvdSBoYXZlIG1hZGUgdGhpcyBjaGFuZ2VzIG9u
IHRvcCBvZmYgc28gSSBjYW4gY2xlYW5seQ0KPj4gYXBwbHkgPyBBbHRlcm5hdGl2ZWx5IGp1
c3QgcHJvdmlkZSBnaXQgY29tbWl0IHNoYSBpbiBMaW51cw0KPj4gdHJlZSBJIGNhbiByZXNl
dCBteSBicmFuY2ggdG8uDQo+Pg0KPj4NCj4+IEkgd2lsbCBoYXBwaWx5IHRlc3QgdGhpcyBh
cyBzb29uIGFzIEkgY2FuIGFuZCByZXBvcnQgYmFjay4NCj4gDQo+IEl0J3MgYmFzZWQgb24g
TGludXMncyB0cmVlLg0KPiANCg0KTGF0ZXN0IG1vcmUgb3IgbGVzcyA/DQoNCkFuZHJleQ0K


