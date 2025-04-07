Return-Path: <live-patching+bounces-1354-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2EFA7D7B4
	for <lists+live-patching@lfdr.de>; Mon,  7 Apr 2025 10:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA323B4C5F
	for <lists+live-patching@lfdr.de>; Mon,  7 Apr 2025 08:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F9C2288F4;
	Mon,  7 Apr 2025 08:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eL4oOE+U"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D3A227EA8;
	Mon,  7 Apr 2025 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014190; cv=none; b=EY9k+lBv7NfGRkBIcflOm7Vg7KQzjNpJ8SerqY+WaHCSuUE4kICr2oOUjjcg3IlOZSbx4MnhMpofYd3ND+Qu9lVlmzLEkkZ87Valhjgb8UFHrjd8KIwenyNxrZpnVpAR7El33po2iGWHUX4Qesi3p4KUUGv74USn/xdCcGWMm6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014190; c=relaxed/simple;
	bh=rjeKD/hvY2D4QqLrTwuauhVk+/iKwdIDjew7UxDVaBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lzON5c+t8ZkJJXNSgB1ajswCj9iEdOOoobnZAz1MK1rVsVFao41UCqkIALIPfYODiV7x5jnTm4U+fNht9qSiAziGmE+lPgkRS4PszNiL+YTnEohdtSVLIWaEPkB4ywp0gFtqKxXB0AplvfOEJA0YmLawBEnXkU/3FoNDOQ4cJFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eL4oOE+U; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 536MGZB3001479;
	Mon, 7 Apr 2025 08:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YPtmPm
	zERDzlYoBQcUrZt2+qPqu0w63jn9JnwFB5X38=; b=eL4oOE+UP5Paq9ymOMhfMI
	0JKnh+QsuVyvf8LF0cOBZ8MJRlNWoZRdC+NJcgZoS9XIgHsvgDP7sh/ppG//kl50
	kRceq5jO2ThMUIVTLYAHMXLjodaCgD7YudErTDGoJvdIeidL15nEs0Tsl+cU8Vbj
	hl9B0Ak4QKjDyiPMMildybCnOjUBcSqWNsoUfaWrlo88QgLk+0SF+NrBO3pw3/uX
	LT/R1sLMDE4CzN1fOwX1t9Xc46pxusCPvEQdtA1Wm3U7O6hDDN7aOoqU3N3O4eET
	CDAOkMYWSBck2UHoJt+F/is3XY0hUV1b5kQb6IDH2SJdPB7a+ndRNX631zsy2ZFQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45v0u0j5f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:22:38 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53789tS7002583;
	Mon, 7 Apr 2025 08:22:37 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45v0u0j5f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:22:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5375GS5M013858;
	Mon, 7 Apr 2025 08:22:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45ufuncy22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:22:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5378MWkQ41812316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Apr 2025 08:22:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92D642004D;
	Mon,  7 Apr 2025 08:22:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FB4820040;
	Mon,  7 Apr 2025 08:22:28 +0000 (GMT)
Received: from [9.203.115.62] (unknown [9.203.115.62])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Apr 2025 08:22:28 +0000 (GMT)
Message-ID: <81b222ec-7635-411f-b72f-804284295edf@linux.ibm.com>
Date: Mon, 7 Apr 2025 13:52:27 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch (v6.14)
To: Song Liu <song@kernel.org>, Naveen N Rao <naveen@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>, bpf@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vishal Chourasia <vishalc@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
 <20250331100940.3dc5e23a@gandalf.local.home> <Z-vgigjuor5awkh-@krava>
 <xcym3f3rnakaokcf55266czlm5iuh6gv32yl2hplr2hh4uknz3@jusk2mxbrcvw>
 <CAPhsuW5yBLMPJy3YNoJKUfP+BEsKOgJZ_BjrJnyUQ=tMPqC7ag@mail.gmail.com>
Content-Language: en-US
From: Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <CAPhsuW5yBLMPJy3YNoJKUfP+BEsKOgJZ_BjrJnyUQ=tMPqC7ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hUVjILF1Tcqp1L0vKDUEync7ugVgzhRi
X-Proofpoint-GUID: kVDfTP40NBM1dQUVNPPWkz3TIKN5O25M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_02,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 phishscore=0 malwarescore=0 mlxlogscore=995 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504070056



On 04/04/25 12:03 am, Song Liu wrote:
> On Thu, Apr 3, 2025 at 8:30 AM Naveen N Rao <naveen@kernel.org> wrote:
> [...]
>>
>> We haven't addressed this particular interaction in the powerpc support
>> for ftrace direct and BPF trampolines. Right now, live patching takes
>> priority so we call the livepatch'ed function and skip further ftrace
>> direct calls.
>>
>> I'm curious if this works on arm64 with which we share support for
>> DYNAMIC_FTRACE_WITH_CALL_OPS.
> 
> We still need to land [1] for arm64 to support livepatch. In a quick test
> with [1], livepatch and bpf trampoline works together. I haven't looked
> into the arm64 JIT code, so I am not sure whether all the corner cases
> are properly handled.
> 
> [1] https://lore.kernel.org/live-patching/20250320171559.3423224-1-song@kernel.org/

Thanks for checking this on arm64, Song.
As Naveen pointed out, with out of line trampoline
on ppc64le, there are a few things to sort out with
regard to livepatch & BPF Trampoline interaction. Will
try and take a stab at it soon.

Thanks
Hari


