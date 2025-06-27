Return-Path: <live-patching+bounces-1596-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6859AEB30E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 11:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A77B7A8F52
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 09:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF4C293C5B;
	Fri, 27 Jun 2025 09:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hOECxpHa"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13015293C59;
	Fri, 27 Jun 2025 09:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751016917; cv=none; b=RlW7XLfwSS2MXrzgF1ewcljCIMbvpO4uLBGZF58/Rj4DUyBG9cM0dUUFUMs3ibqtyBSD22y9qSZPZAoCx+R73G99J/J5BhggwLF6MDvToOOCghXQVV6o/t5hjPl9alUCN4o1SBS3o0+IUOH4hTgYfdjQ845MaOjwEN8tfAlr+kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751016917; c=relaxed/simple;
	bh=aYHAzugYLIyEa4ubHqJEW6Mwulpb4MIrhv4Bu5CACas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdSaMyFCwx3of3nY+/Nk7J9Rjgsh+6IwRiQ205B1j6sb2Yn6iDfSIGRgofogF3Ge/C97jq1zr2DxzNyJCkTpc86OAcV6PhAkD55qEATw9/5Q7BVNp+PGDMGpnvuGOYa62pQ8gPL0Cwx/G5Op+qcEyneOdbo4587hN5cQ7A1uH9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hOECxpHa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55R7isu9010455;
	Fri, 27 Jun 2025 09:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=G0u0oILqVCwN5YUicdQ8F58a/l2fSa
	z5vBpoIL/fgcc=; b=hOECxpHab0pd1lQLbO94DDi+tVmhTcPM0YC/YmWzrIE5qW
	CHsbryJViYWNX4TXY+EKOELPrfu3UWGZVfzEKXvef2vR2C9lvc/h5KhgwmvlIZTn
	yeiSKz/etytIFC9UsRghFBSLtkCsoC/Ahy9MKy4XcMuMBSSXAYD7f9Tvr9QYs3pG
	3xU7d3oS5H0dbNHyiCJ2zYA5E5BATpYlmQu8Tq+kBGzdNfWQti0iVNjbmTgcbg/O
	lC63M487nFeAyGO76yj/nq1Ev0dc65wZgnZPBenCk7niia/rt2WBAb68IhWeaIvv
	vBD/9bnLJe6O24COKHNZqYFaIvvx+jUghSo9X21A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47gspht8gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 09:34:49 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55R9UOCd020374;
	Fri, 27 Jun 2025 09:34:49 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47gspht8gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 09:34:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55R96m62003994;
	Fri, 27 Jun 2025 09:34:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 47e99m385d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 09:34:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55R9YiWn59441650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 09:34:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2440920063;
	Fri, 27 Jun 2025 09:34:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 428E920067;
	Fri, 27 Jun 2025 09:34:43 +0000 (GMT)
Received: from osiris (unknown [9.87.133.27])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 27 Jun 2025 09:34:43 +0000 (GMT)
Date: Fri, 27 Jun 2025 11:34:41 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
        Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v3 01/64] s390/vmlinux.lds.S: Prevent thunk functions
 from getting placed with normal text
Message-ID: <20250627093441.13723Cc6-hca@linux.ibm.com>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <aa748165bf9888b0a7bd36dc505dfe8b237f9c62.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa748165bf9888b0a7bd36dc505dfe8b237f9c62.1750980517.git.jpoimboe@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fe3LNM31hmI-ErQ5KLeZVwQYtEaINleh
X-Proofpoint-ORIG-GUID: c13wTOi2JO6eUTq-HbyluyI3E9FBmqDF
X-Authority-Analysis: v=2.4 cv=Hul2G1TS c=1 sm=1 tr=0 ts=685e65b9 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=awXcams9sirMRC52x60A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDA3NSBTYWx0ZWRfXxllruMVAWW6w KEi2biYzA3K0u+UNfuWl70ba+fUPbMx9FLt9ZqIZlFthnje/ctkWyYBwOSncozIOXRTG3hI++U9 O4SWtnRPC6BtPXRhZF77NAWTfAio/8xSE3ZweThFC252NuTUDz/xQT1lPI7D1Ifjyx6NfXUwMI7
 5qf2pS42mKljBPp9/ccGMShOd6I5tmd2vwxQtIlojjfDybxnLKO2AZ7gPilVpoD5PHXi77q7DYY asN7Ik3Xq6tfAkcRvy5c2s8iY8ZbBHaftmp91qgK+vAn9Pxs0FKxejKBYCQteC4T+/HBLKgDbek NDAsWP4mELniCi395n0BOwAgkBTIQ3TJBM39e5eq/NFuonbz87fppct1cRnCPulnAzLZy2rSfpn
 KgiEOvB3wqufv+sHxVS16a9pqpKHULVmA8/0qflzWy0vCFdivnOWZe9UtfURUe8tNqHlb9Ek
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_03,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=530 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506270075

On Thu, Jun 26, 2025 at 04:54:48PM -0700, Josh Poimboeuf wrote:
> The s390 indirect thunks are placed in the .text.__s390_indirect_jump_*
> sections.
> 
> Certain config options which enable -ffunction-sections have a custom
> version of the TEXT_TEXT macro:
> 
>   .text.[0-9a-zA-Z_]*
> 
> That unintentionally matches the thunk sections, causing them to get
> grouped with normal text rather than being handled by their intended
> rule later in the script:
> 
>   *(.text.*_indirect_*)
> 
> Fix that by adding another period to the thunk section names, following
> the kernel's general convention for distinguishing code-generated text
> sections from compiler-generated ones.
> 
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/s390/include/asm/nospec-insn.h | 2 +-
>  arch/s390/kernel/vmlinux.lds.S      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

