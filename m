Return-Path: <live-patching+bounces-1890-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFD9C9D095
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 22:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 169F6346ECC
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 21:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95C02F6931;
	Tue,  2 Dec 2025 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b="sHzWrFVH"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00206402.pphosted.com (mx0b-00206402.pphosted.com [148.163.152.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1249212574;
	Tue,  2 Dec 2025 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.152.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710297; cv=none; b=h3HQhxzZX6DhX641rOV1SUTUXYhzbuG3VMusBZkePamaBz5WFspivuwhk24NcOLjcjVX32QYsxtj7irEonpdChFePmRC5tmbqLgltTaZpuTTu6nuOUm+r4tYreh6lTaOUpElyCGMG1Xo1duUJ9ieScmME7iqSRb/3+ae2brFz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710297; c=relaxed/simple;
	bh=0oQJq9fPKKlX6XGT2m4c9jCZSrgZNyoNDR+imEX9pDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XzE/PMhokuQnKPR1OSlDYwUj3YLKF4LooDUSbJvffWgtqO8Hmqcu1fxBioIV8Ajopc34xrimqA0t0m+MiYgPixMNobBxYuZmA5pVcLoLip7cAIjy2IFgvYJRdkESk8zRbK6gWtd7Nqwu1pKKgaKhFDtNbzDX6YAipBE2rKNoc3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com; spf=pass smtp.mailfrom=crowdstrike.com; dkim=pass (2048-bit key) header.d=crowdstrike.com header.i=@crowdstrike.com header.b=sHzWrFVH; arc=none smtp.client-ip=148.163.152.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=crowdstrike.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crowdstrike.com
Received: from pps.filterd (m0354653.ppops.net [127.0.0.1])
	by mx0b-00206402.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B2KbwQs1400308;
	Tue, 2 Dec 2025 20:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	default; bh=0oQJq9fPKKlX6XGT2m4c9jCZSrgZNyoNDR+imEX9pDk=; b=sHzW
	rFVHmsAyOmt9/NHqS1GfFoKYdLbQ+A4depWqCw1H+FjWUukOfHrBDpYKlH/pklmA
	Qagw5LVjmKdfQDzyk3jqUo5Ir3m2pzTgEzdBF/pcrqazx3pszGI3p23UcMdgLV7O
	UZ8Ynltrlfa0ejSddsvJcpPnzkzfb+L8nzzCLaVKIbO6/S6hCudJTSKRnmTSos04
	Xh//z4iQ8Uks0Sa2V3RwH1EIdb+QIR6qdFOloHXANXeQm4T5kuUXkP4crxrHvDeo
	XbaFdijXEqdK8KUA9qIDyz4W2L3+tw0BAXTPGd6JrRaePSUk2a+mnytD68+QTJ9h
	+aQi9tCyVzqRsLn2zQ==
Received: from mail.crowdstrike.com (dragosx.crowdstrike.com [208.42.231.60] (may be forged))
	by mx0b-00206402.pphosted.com (PPS) with ESMTPS id 4asrj3u6c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 20:56:29 +0000 (GMT)
Received: from [10.82.59.75] (10.100.11.122) by 04WPEXCH010.crowdstrike.sys
 (10.100.11.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 2 Dec
 2025 20:56:27 +0000
Message-ID: <fe0e9330-8ad7-4835-9ba9-adbcbe40e6a3@crowdstrike.com>
Date: Tue, 2 Dec 2025 15:56:26 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] [PATCH 0/2] bpf, x86/unwind/orc: Support reliable
 unwinding through BPF stack frames
To: Josh Poimboeuf <jpoimboe@kernel.org>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <bpf@vger.kernel.org>, Petr Mladek <pmladek@suse.com>,
        Song Liu
	<song@kernel.org>, Raja Khan <raja.khan@crowdstrike.com>,
        Miroslav Benes
	<mbenes@suse.cz>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann
	<daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra
	<peterz@infradead.org>,
        DL Linux Open Source Team
	<linux-open-source@crowdstrike.com>
References: <cover.1764699074.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
In-Reply-To: <cover.1764699074.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: base64
X-ClientProxiedBy: 04WPEXCH013.crowdstrike.sys (10.100.11.83) To
 04WPEXCH010.crowdstrike.sys (10.100.11.80)
X-Disclaimer: USA
X-Authority-Analysis: v=2.4 cv=ZqPg6t7G c=1 sm=1 tr=0 ts=692f527e cx=c_pps
 a=1d8vc5iZWYKGYgMGCdbIRA==:117 a=1d8vc5iZWYKGYgMGCdbIRA==:17
 a=EjBHVkixTFsA:10 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pl6vuDidAAAA:8 a=1FlXtNax5hujNQ4drgoA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: Maluk1nTjm-Qxq--AovnNRXqEO98DrH5
X-Proofpoint-ORIG-GUID: Maluk1nTjm-Qxq--AovnNRXqEO98DrH5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDE2NCBTYWx0ZWRfX36+TuEzH0QtS
 8Ws8U3EcIQQjRgCBNpU4LJxufj9x2Amec6quFC6X4aOWfH74T5AnRonJQAaWgLM10HBgcX0OIHO
 eoL9WBqLgitiTi2XxDis3rd6BKQ7YnGzQ9L3qTNRhi46E3A/wiBS1HSG3HQhqdVfxYNIbdsZSF+
 1JMH66LrhM0yywn6odHUV/5ohM7j+ZdBA3jLUchkcvAnxBF/0/asavqe98+RzH8sxWOgbeDCSej
 Q/bGQcrnj6cB6hyfSlGMWzHoalzMuXVQbxHCKwzoN8FhllMzaSgkhYv3iDOjZe3/8kA+ztvG/9L
 ogGTvOQMjeZw7/xiMUQYvE5dUM+pKm6tmhFQxBp024DrIzTX7YmPXZodN40t8pmdiskXyX9g6yE
 bjSGVyC36psPKa6nlSmoXB5l5tEBdA==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11631
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512020164

T24gMTIvMi8yNSAxMzoxOSwgSm9zaCBQb2ltYm9ldWYgd3JvdGU6DQo+IEZpeCBsaXZlcGF0
Y2ggc3RhbGxzIHdoaWNoIG1heSBiZSBzZWVuIHdoZW4gYSB0YXNrIGlzIGJsb2NrZWQgd2l0
aCBCUEYNCj4gSklUIG9uIGl0cyBrZXJuZWwgc3RhY2suDQo+IA0KPiBKb3NoIFBvaW1ib2V1
ZiAoMik6DQo+ICAgIGJwZjogQWRkIGJwZl9oYXNfZnJhbWVfcG9pbnRlcigpDQo+ICAgIHg4
Ni91bndpbmQvb3JjOiBTdXBwb3J0IHJlbGlhYmxlIHVud2luZGluZyB0aHJvdWdoIEJQRiBz
dGFjayBmcmFtZXMNCj4gDQo+ICAgYXJjaC94ODYva2VybmVsL3Vud2luZF9vcmMuYyB8IDM5
ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KPiAgIGFyY2gveDg2L25l
dC9icGZfaml0X2NvbXAuYyAgfCAxMCArKysrKysrKysNCj4gICBpbmNsdWRlL2xpbnV4L2Jw
Zi5oICAgICAgICAgIHwgIDMgKysrDQo+ICAga2VybmVsL2JwZi9jb3JlLmMgICAgICAgICAg
ICB8IDE2ICsrKysrKysrKysrKysrKw0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgNTYgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KDQoNCkFja2VkLWFuZC10ZXN0ZWQtYnk6
IEFuZHJleSBHcm9kem92c2t5PGFuZHJleS5ncm9kem92c2t5QGNyb3dkc3RyaWtlLmNvbT4N
Cg0KUXVlc3Rpb24gLSBUaGlzIGxvb2tzIHRvIGJlIHg4NiBzcGVjaWZpYyBpc3N1ZSBzaW5j
ZSBPUkMgdW53aW5kaW5nIGlzIA0KeDg2IHNwZWNpZmljIGFuZCBhcyBzdWNoIHRoaXMgaGFz
IG5vIGltcGFjdCBvbiBBUk0sIGNvcnJlY3QgPw0KDQpBbmRyZXkNCg==

