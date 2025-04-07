Return-Path: <live-patching+bounces-1353-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B27A7D781
	for <lists+live-patching@lfdr.de>; Mon,  7 Apr 2025 10:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C09E33B9348
	for <lists+live-patching@lfdr.de>; Mon,  7 Apr 2025 08:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94EB0226883;
	Mon,  7 Apr 2025 08:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TfYaQwIs"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C82253B7;
	Mon,  7 Apr 2025 08:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744013826; cv=none; b=RtlYCadek+ZBWKdvE5a+Hd4K2YJAlEGjXoG7yA7TjwNKP4CLeSkWgjX56VlXK+WcQaW/RrCaGATKc9seSkiiXR4YCQFIQppU5SKss5MEfMWHRq4Ez9ZMeaJPtI9MQAPAWL1BDhWoORoGTYCu23FpoeoyXrLX+mcNcl4seFUESKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744013826; c=relaxed/simple;
	bh=XyBtcSlcZdGNBXvueFeCr4yhVGyfP64cK/j8eqDM/zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBjXjVwQqUzlJP7d0xB3tq5xfshOBEfnuxWkRWP5oFnQaVzTyD3VYKI8YnZ4o/sdkKepC51FuXrnG6no1794oOU70C+0VCvW2vgdcmjjIZgaNnBFdIaDt1X1VYdVtRbhnhOAuwVojjy05dbnfEm3STLBvgD9rqC2XALgNXVuAuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TfYaQwIs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 536MGZZu028164;
	Mon, 7 Apr 2025 08:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nabt4M
	TzF21qlD7olPmRrgXeKPdV2cuXz31d6xns7pk=; b=TfYaQwIsEXj0+xl/be2u3N
	Sfq6LSaTC8uXkIWwKYeIbOtt9EPT59/boI0gkBhdagb8tMlwJZyI5t4ZK2MYa8z8
	QFK181Ubw/S8LHF6ivpB8U23+daactok/GrDx4KzH0fLYouxkC4O0o4CSbe1Otw+
	vRGk/ZJVOZMQnIfeeCvW8j7KtR5EZIAqdDve1zXY38+Q6dhFW3lSdqU28/92RQY8
	DLzit2IQSqT0DwDGoTb/evs4yVYZ5e8y4cZiVmef+OC9rR1XXxQSju8izu2ooID4
	kdzD5cGAH+NqsAIQBzM4UFu9gub9/fkxMCRCPbEZ5SApxY5wzWQQ7Rt8WrpynErg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45uwswtnvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:16:30 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 5378FFoK018849;
	Mon, 7 Apr 2025 08:16:30 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45uwswtnvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:16:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5375iRVK025562;
	Mon, 7 Apr 2025 08:16:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45ugbkmvda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 08:16:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5378GPIu56623414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Apr 2025 08:16:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B98A2004B;
	Mon,  7 Apr 2025 08:16:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B555D20043;
	Mon,  7 Apr 2025 08:16:20 +0000 (GMT)
Received: from [9.203.115.62] (unknown [9.203.115.62])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Apr 2025 08:16:20 +0000 (GMT)
Message-ID: <873f3934-e964-49d4-a312-1debb1c77255@linux.ibm.com>
Date: Mon, 7 Apr 2025 13:46:19 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch (v6.14)
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>, "Naveen N. Rao"
 <naveen@kernel.org>,
        bpf@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Mark Rutland
 <mark.rutland@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Content-Language: en-US
From: Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CiVB0C82QOgMH9tKUtHz9g8EIftRWHzy
X-Proofpoint-ORIG-GUID: m4LySXxzR5w3uK0HEcFy_rQKR8xuJbln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_02,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1011
 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504070056

Hi Shung-Hsi Yu

Thanks for reporting this.

On 31/03/25 6:49 pm, Shung-Hsi Yu wrote:
> Hi all,
> 
> On ppc64le (v6.14, kernel config attached), I've observed that fentry
> BPF programs stop being invoked after the target kernel function is live
> patched. This occurs regardless of whether the BPF program was attached
> before or after the live patch. I believe fentry/fprobe on ppc64le is
> added with [1].
> 
> Steps to reproduce on ppc64le:
> - Use bpftrace (v0.10.0+) to attach a BPF program to cmdline_proc_show
>    with fentry (kfunc is the older name bpftrace used for fentry, used
>    here for max compatability)
> 
>      bpftrace -e 'kfunc:cmdline_proc_show { printf("%lld: cmdline_proc_show() called by %s\n", nsecs(), comm) }'
> 
> - Run `cat /proc/cmdline` and observe bpftrace output
> 
> - Load samples/livepatch/livepatch-sample.ko
> 
> - Run `cat /proc/cmdline` again. Observe "this has been live patched" in
>    output, but no new bpftrace output.
> 
> Note: once the live patching module is disabled through the sysfs interface
> the BPF program invocation is restored.
> 
> Is this the expected interaction between fentry BPF and live patching?
> On x86_64 it does _not_ happen, so I'd guess the behavior on ppc64le is
> unintended. Any insights appreciated.

As Naveen updated in another thread already, this behavior is expected
as ppc64le does not handle it. Will take a stab at fixing it.

> 
> Thanks,
> Shung-Hsi Yu
> 
> 1: https://lore.kernel.org/all/20241030070850.1361304-2-hbathini@linux.ibm.com/

fwiw, the above patch was necessary for fentry, but the support was
complete with:

  
https://lore.kernel.org/all/20241018173632.277333-18-hbathini@linux.ibm.com/

Thanks
Hari

