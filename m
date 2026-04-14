Return-Path: <live-patching+bounces-2348-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WG3HIo1o3mmxDgAAu9opvQ
	(envelope-from <live-patching+bounces-2348-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 18:17:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0473FC70C
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 18:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4112630982A5
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 16:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A8E3ECBC8;
	Tue, 14 Apr 2026 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bjbrj4Pg"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928CE3E959D;
	Tue, 14 Apr 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183075; cv=none; b=LzNc0l2oxfo9h1Rv5tN3quqkq3lrrW8JGZYVuRhhrwa8fg1P4nZbKutaRZ+JOINmffE+cXdiNf9o7A7cOsFVsrwwqNy0pgIQEj3A1R0EtXGuyXKMZMz/7nHsV2DXIExSwmfXIEvKc6yAlhKTIT3Z38ycqwhXj08oErLzDRvQqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183075; c=relaxed/simple;
	bh=/nasxjWRWhFVRuYYtDCdZJM1QVHz+XfdKRi1L2425Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAIdDcMXbMjuCOjMFi1DNk09ggN/b4iGXr6LBAC0j3gao9YBJ5daFz+vDL1yKNNez7BQwDgumCp5GqaFnuzVvVF4gLRi6Hv20s1wgOTMzd0Mujsmvf8ynkGe/c/Xl17XVAxE68uFd4G4pP1OAkKeZYIDPRgqIaqTxx6f8cmQNaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bjbrj4Pg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EEWv2J1842742;
	Tue, 14 Apr 2026 16:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xkgEun
	Iybz/uxHtgdoi9HPYkRW3cWxQhmhXZ60Km/OQ=; b=Bjbrj4PgenYyjPDRGsg/QU
	E9NsAXuNeQgMPWF4A/IxLAvYI5uxJgbwojOYm0uXg5U4HSl+FxBmapfp7GMOuFRD
	pyS/J2CUeC9t/Z0mUtmnI/FMXd13Q8EQbhclpT81uM9f1ArzTM5k+W9cv+6ZyNEU
	cHsBTJ4PTArou4bHbAXK06b9LtO2ZeEMv2HnECe+sixrNIg5scEDxs/fwvlSM5BH
	3oE9wObWRX0e1FP+LcIkLRO9CZ5oVC/6KbvTOaX/luzqaQXwvJCGS8rXfwFK1O/E
	vM8mR0CuDEfC/dk4Yb4kAQ41Kebh2gEaS4yZ1pemdnX9DuCPjOl1LSww/zLwEZOA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mkppf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 16:10:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63EEweMq026284;
	Tue, 14 Apr 2026 16:10:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujj4h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 16:10:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EGAYGD29032930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 16:10:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 324232004B;
	Tue, 14 Apr 2026 16:10:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D055420040;
	Tue, 14 Apr 2026 16:10:33 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 16:10:33 +0000 (GMT)
Message-ID: <c1d306dc-c6da-4ae6-8cc7-6133e253334b@linux.ibm.com>
Date: Tue, 14 Apr 2026 18:10:31 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] unwind, arm64: add sframe unwinder for kernel
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20260406185000.1378082-1-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE0OCBTYWx0ZWRfX7eqnRXSdZg4v
 glBjYWKYGKBs4G24BhjG6Utm6E8Yw+TfyJxD9Si0jZPY/67mJDI7pUaiJOQBIlnNYup+XBRaqUs
 PEzSBdVyU7Y3Tir/sJZjOdFTqghkyQP7N+Y4Tavg+7hQpAM/TYBu3h1Vk4867xqPqZUmYbVhL7j
 YzDx691+QzSrwr3UndTlgJ/oioBpvo2DXnHToPR1lUHpWwaTF01hVEoCvR0oHgksjOmyNP6y+aF
 FOWtifBFnzD6A627BzbKr66+Si2NQSCTIfPtF6T1+/kw6y2LCY2SSTJTU/b3+x5HFnIKiqZL4p4
 jcHi43Y9kJuaS/mEXEz6k6M+rQsoliJuQDTiV1RQfcDxJMFcl2DZ7r0fXqrijQyohqJAIoLXxVM
 WMEEenyXrDGQFRAFF0uv2t7LIede3fJ00fQBK/3DUjvv7nF9q6GYleeA91/hYAFPyfrIqnuyJ7z
 +w2Ujw/v1oh/wnZQcCg==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69de66fd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=Zg_fgM-7fzLk7_7bOdYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: 3m3_VBFCWvmOrIMnl-0WlOdsMwD0_RKw
X-Proofpoint-ORIG-GUID: CH-2a-nuGZI5u_Lb2b4gbgN4-GM4wBNM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140148
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2348-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: DD0473FC70C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/2026 8:49 PM, Dylan Hatch wrote:

> Dylan Hatch (7):
>   sframe: Allow kernelspace sframe sections.
>   arm64, unwind: build kernel with sframe V3 info
>   sframe: Provide PC lookup for vmlinux .sframe section.
>   sframe: Allow unsorted FDEs.
>   arm64/module, sframe: Add sframe support for modules.
>   sframe: Introduce in-kernel SFRAME_VALIDATION.
>   unwind: arm64: Use sframe to unwind interrupt frames.

Nit: Trailing dot in commit subjects seems unusual.  Remove?

> Weinan Liu (1):
>   arm64: entry: add unwind info for various kernel entries
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


