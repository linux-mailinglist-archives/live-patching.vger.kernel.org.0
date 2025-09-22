Return-Path: <live-patching+bounces-1723-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 337EDB8F092
	for <lists+live-patching@lfdr.de>; Mon, 22 Sep 2025 07:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90A40189C40B
	for <lists+live-patching@lfdr.de>; Mon, 22 Sep 2025 05:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D62230268;
	Mon, 22 Sep 2025 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HVWRWzX2"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40235C96
	for <live-patching@vger.kernel.org>; Mon, 22 Sep 2025 05:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758519865; cv=none; b=q2tJl5Y+2i/9Gp9GJIZWBJUfdhaIkVlJZwo4qS3Tvf2aPpRhZlEvcDhoUSqD91yEI0AD2YHlhXyaGV2ZjcIs9rj4/b4MDht85ChN8UWS5oqpeIo96D36NRCy5VvUGjg+N9SytefkGtc0Nwa8EMws9ukVuJQCwBGLw3aBUEhy5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758519865; c=relaxed/simple;
	bh=tfj6tRNotom9tYglKH2v2Hp65GSFoFqZFvOJYglKFuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpTX8WJz3TdBmbmyi/uIU/kpQCX0uAnhwdf92q7c0oU7qobEbnqfU9VCTpZxCUIXkCCfoUc/S1cSjS1mANy4EJD8XH8A+Es1XuWoBn94qv8Bl5NZj4Bogn+oK4C4zz/FRwdYukw1DYpH+Y1Zquepx4Wn9Zl2VmDHj1fceY1hS/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HVWRWzX2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58LMCS6T016178;
	Mon, 22 Sep 2025 05:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QZyFyq
	ONOAH11zhMr8nWVKhp9+n8qNVxohhDrJUm9g0=; b=HVWRWzX2Gs8k0h/PMRt62u
	UUtzkQ94rrJBFOyCo97kjNMys2EVhmlLd8+8Jwp424YDSkTHkGjJ1Nwf8okJy05g
	7cI+j5HcaPTcZd7ISRyxy1Uw3QxOX3t41J8vnEs3+oZ6pJAh91JPgzugIshzpYXe
	GsE4eMmz3mbD8IGeaOPO+9Sf/quYG56jGIUOGkwYZW7I/0iMOFUbxSl8l130Z9Md
	wtC4n01S3b5la1hQgGi7HT/A9xiAT9KqJiG3aXcvzvOvR3oqBO2696k7nKY60mEq
	nWUUHdrBiqZDH9oPD5QApaeJFlL+RztPXAtW86ulCowiVyTl+hMSUOLvxYXMRpxQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpk0gre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 05:44:06 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58M5i6VJ031161;
	Mon, 22 Sep 2025 05:44:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpk0grc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 05:44:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58M16xL1013704;
	Mon, 22 Sep 2025 05:44:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a8tj4cjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 05:44:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58M5i3pJ55640452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 05:44:03 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 915DE20040;
	Mon, 22 Sep 2025 05:44:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F47720043;
	Mon, 22 Sep 2025 05:44:01 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.ibm.com.com (unknown [9.43.82.69])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Sep 2025 05:44:01 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>
Subject: Re: [PATCH v2 0/3] powerpc/ftrace: Fix livepatch module OOL ftrace corruption
Date: Mon, 22 Sep 2025 11:14:00 +0530
Message-ID: <175851974397.1538174.4405570975421605487.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250912142740.3581368-1-joe.lawrence@redhat.com>
References: <20250912142740.3581368-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=L50dQ/T8 c=1 sm=1 tr=0 ts=68d0e226 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=hyQcYdjoVnPOfAs-bJkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMCBTYWx0ZWRfX7NtLggyMBvaS
 pnixGtmwIPRw1nhX7U8JlBADFX0QNJMdLYqDRE9zXp2Hl1NKcXphojyrbVO5y5sX5wAgdk0GWfu
 eI39LniB9UoA6J/9HX1ADXLsEH5C9JMb+GasRSDjRjcnBgqn0hYu0raGbSGeNWY5+jZ8cRKGq9h
 JDdca3wKiWegw5bTlU2KpfPcZrw9kpcpP9UaAsS74zAlUnJMtWR0I5jAm7p5nWuk4LSTCgJ+vmv
 yOPEqKJ5unljt2MzVTwFmiA4gC0+okuSDVMWEyDZlbtySaN4BqTn94JSThDD9uENmNr+UdxCDh9
 1NCNLeTL1XiDnDNK7v4tNNxZ/UXapufE7BF+4Bkzu0JGN+Tn0dT8zxn3Pc8PfLKwNuXYBpP1WTD
 +075JBJL
X-Proofpoint-ORIG-GUID: HthdyeIkGkHuyzkSUfcQAiGjWpggGrL3
X-Proofpoint-GUID: -Uz33uZKt4UnYKmpmDOuD3VWK543S-AX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-21_10,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200010

On Fri, 12 Sep 2025 10:27:37 -0400, Joe Lawrence wrote:
> This patch series fixes a couple of bugs in the powerpc64 out-of-line
> (OOL) ftrace support for modules, and follows up with a patch to
> simplify the module .stubs allocation code. An analysis of the module
> stub area corruption that prompted this work can be found in the v1
> thread [1].
> 
> The first two patches fix bugs introduced by commit eec37961a56a
> ("powerpc64/ftrace: Move ftrace sequence out of line"). The first,
> suggested by Naveen, ensures that a NOP'd ftrace call site has its
> ftrace_ops record updated correctly. The second patch corrects a loop in
> setup_ftrace_ool_stubs() to ensure all required stubs are reserved, not
> just the first. Together, these bugs lead to potential corruption of the
> OOL ftrace stubs area for livepatch modules.
> 
> [...]

Applied to powerpc/next.

[1/3] powerpc/ftrace: ensure ftrace record ops are always set for NOPs
      https://git.kernel.org/powerpc/c/5337609a314828aa2474ac359db615f475c4a4d2
[2/3] powerpc64/modules: correctly iterate over stubs in setup_ftrace_ool_stubs
      https://git.kernel.org/powerpc/c/f6b4df37ebfeb47e50e27780500d2d06b4d211bd
[3/3] powerpc64/modules: replace stub allocation sentinel with an explicit counter
      https://git.kernel.org/powerpc/c/b137312fbf2dd1edc39acf7e8e6e8ac0a6ad72c0

Thanks

