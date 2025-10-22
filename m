Return-Path: <live-patching+bounces-1791-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4221ABFCB57
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 16:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A20A6E0AC2
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 14:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A51335BDC6;
	Wed, 22 Oct 2025 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XgkmEh1f"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A735BDC0;
	Wed, 22 Oct 2025 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143602; cv=none; b=H2NSfiMsZaTq6T+PXSLEE4Tv2FaAGvTxRCkGrtyS+H5DnTQyZ1HQG0y5ckjvoD4LPO+oDhsaUn7/61EVi0yekMEYnQNDBiAcpHB7l8buZTIkrL8u1ZyASxV7O4ZVJz81FtAv+LgtVdNEz8JZe+yVlUzdLQr82fqgAAVyUFiFALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143602; c=relaxed/simple;
	bh=KWBuXgWRAPLeCtQIQU7TyXN77cQjfbuw3kotxX0JfhI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XOT/JJcL/8Q49SIx1jyBc/YXoLiTXwUmuzF6u52IlVYwce0h9AjQ48zCdzg6oWSuXhvJJAcsEw85UNTXmk0WRTemCSBfaeSsD2EqJ57Mp7u/o1UoNR5T0+RoiZeTotmfgauysk/Tl7KLbXPxkFJMVjimbe4B1QpNl+1ZdFXbvWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XgkmEh1f; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MC9EGU005743;
	Wed, 22 Oct 2025 14:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PyivFS
	RDBhhSZfn7SL3PxVgZkMR8t6cM+gk4Y87DeRo=; b=XgkmEh1fB/ZP2GOhXkXiIj
	2Kag60jw3LNXEZU3B9glUxJNh0ekQVhIs24YPhyI9Wc0uKUW3d3ss9XffOvasj6i
	Uoa+jPMFECeQXU60fd8agZJH0lrG3OLPValraQ60bkb/6yFc464xpH/nIinJrAau
	00aomIP0pSIti2Kk/r/XnPkOeInZNCJmVM5sT23vGihNJSROE28ceN77Tpit4GPW
	RRgsy0yKr+jKsmqfDMfU1HzTJZvWr2W2+/4HzbH/NUuE5EPX9XzAWtFMyq4fIPQW
	U+M0OBAB65fXwyhuc/OkoE7jbKZA5RO6kg+GerLitFTkd5y/8lBSjqyT+QBTpnLg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s58d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:32:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEVd9f000954;
	Wed, 22 Oct 2025 14:32:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s58d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:32:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MDj7Qi017066;
	Wed, 22 Oct 2025 14:32:35 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnky0wym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:32:35 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEWZhR41157198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:32:35 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA40658052;
	Wed, 22 Oct 2025 14:32:34 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE2E65805A;
	Wed, 22 Oct 2025 14:32:28 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.243.114])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 22 Oct 2025 14:32:28 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH] module: Fix device table module aliases
From: Venkat <venkat88@linux.ibm.com>
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Date: Wed, 22 Oct 2025 20:02:16 +0530
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
        Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Cosmin Tanislav <demonsingur@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF2ED6EB-3080-4C9C-AF4B-A95EC8C8DF82@linux.ibm.com>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.600.62)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9I2TXZ4ju9LOKbYrKPJKpMm_tWpAdfM0
X-Proofpoint-GUID: I2xOa9DOzDwwIbPZw1joxXScrowTtyCr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX+Sf2JTz4i63j
 uAZ9PZ5sKdPN+RsvlEQDI7yXMC2zhNpgLF3Pl3/p1cR2CfV9WOePoTahQ/aPIWAKR/7IpWn/ASb
 samdNZnbzk4HyTEAJDsvAz22GEWH+FIlg0ifY9Q5yeg2U70XVq0wAGW0gfAYRPl+rNTYUOaySZ3
 5zVPw/2rmZIIDPayi+8T+cVrxFbykgCxy/wqHO5y4E5gFjwO4IHlHEXQgg0dFLgGHQisbbBf/JA
 aDDI8Oon1E8DmMW0G6XWAV8i1O/dMascxm2d+KBsVBlkYvNiaDIf0u0wMP8y2+A0ASeHcaj+01S
 Dx5OG+qp4ZWLyT5fAzx4wCDwCVXLU4mkHcwGexmWtpqFHGS+gOMSdwub/mEtjZgobuurWoHcDEK
 00g4JaQroM/aYElarc4OeIv413tGew==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f8eb05 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=8f9FM25-AAAA:8 a=hD80L64hAAAA:8
 a=pGLkceISAAAA:8 a=I3dIXEeuN3GIiXp40RkA:9 a=QEXdDO2ut3YA:10
 a=uSNRK0Bqq4PXrUp6LDpb:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022



> On 20 Oct 2025, at 11:23=E2=80=AFPM, Josh Poimboeuf =
<jpoimboe@kernel.org> wrote:
>=20
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
>=20
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer =
matched
> the format expected by handle_moddevtable() in =
scripts/mod/file2alias.c.
>=20
> As a result, modpost failed to find the device tables, leading to
> missing module aliases.
>=20
> Fix this by explicitly adding the "kmod_" string within the
> MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
> format expected by file2alias.c.


IBM CI has also encountered this issue. I have tested this patch and it =
fixes the same.

Report link: =
https://lore.kernel.org/all/cdf7c458-b28f-4657-8708-1f820369baa6@linux.ibm=
.com/

Please add below tags.

Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Regards,
Venkat.


> Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from =
__KBUILD_MODNAME")
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
> include/linux/module.h | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/module.h b/include/linux/module.h
> index e135cc79aceea..d80c3ea574726 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -251,10 +251,11 @@ struct module_kobject =
*lookup_or_create_module_kobject(const char *name);
>  */
> #define __mod_device_table(type, name) \
> __PASTE(__mod_device_table__, \
> + __PASTE(kmod_, \
> __PASTE(__KBUILD_MODNAME, \
> __PASTE(__, \
> __PASTE(type, \
> - __PASTE(__, name)))))
> + __PASTE(__, name))))))
>=20
> /* Creates an alias so file2alias.c can find device table. */
> #define MODULE_DEVICE_TABLE(type, name) \
> --=20
> 2.51.0
>=20


