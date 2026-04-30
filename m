Return-Path: <live-patching+bounces-2614-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8ObSFK0r82mwxgEAu9opvQ
	(envelope-from <live-patching+bounces-2614-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 12:15:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2AB54A09DF
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 12:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F50130DBF47
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 10:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E6F401A0D;
	Thu, 30 Apr 2026 10:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YAzDcjQg"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008D401483;
	Thu, 30 Apr 2026 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777543487; cv=none; b=OC6gHG3HRpJSpayS0SG92QC7bEVIblFbBNU8nt64BoDAW7OXqvzq57fENDLXkEHNU9kMmbnUQJ2teGYlfnSdTO8lU5iE5w/7VplDucmjb/vpo8xoqiJkICdoHbrXKwxtxYS3p2ExywveQw8gj4Grl202GZElveFq/HItzZqzifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777543487; c=relaxed/simple;
	bh=ydDGlMxsHgJvoWlbd0vdAFJmSMfPZZMtucp4dyTHDyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ic1XAsh74G3Z9rTFKMkJ1MhA3hcLiIm8croNCYUPEG/FG6YuhLOAY8K9LF51N6XIZ+axqtOraq7oFjRDYQBXJv/JCTu/umCHeKCPTUjk2Itx7+b5cPhka9rUDtyfdMIyDLaz1DXiEgl4SEBTKQIog4hs96CkX0AzbAqdxtldLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YAzDcjQg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U7SUuA996575;
	Thu, 30 Apr 2026 10:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ekjrcZ
	YHERZenE83ZIfheqQI0RapxQLtaYQ2BGyVATU=; b=YAzDcjQg801acHa/MFZUTJ
	zbWiWHELeHr8e5Me5mna2rASRZJP4k/dK5/Lmi60yAR+oQIlY8HS2igWu+GucgGv
	dbvNL0p+gnvYGEIQiSgzk8Wdbf3U7cSXgfPSq/QSQQSjfrT3hgGtweY3KedpDPls
	k019+ONnITvenKhYQXnCd5a1eoHij3+g5uxQ5DCjGom66mFe4r7pYzWhIXY9bKqr
	CxdmkQHm3XRkrpeY249aRaaTqKUV5HzFgLgOnH7UWJLT/TKJ3b62MzVkTMiTMtzH
	4p1m27ybwZpWKFhOHSB8dLS846ZXQ3e0mz/SNrzSMLqqCJ3ElQiKMC2LCi/DqvRQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn8vnb1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 10:04:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63U9rkYS023446;
	Thu, 30 Apr 2026 10:04:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8xkadnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 10:04:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63UA4Fs360031408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 10:04:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9250F20040;
	Thu, 30 Apr 2026 10:04:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2582220049;
	Thu, 30 Apr 2026 10:04:15 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Apr 2026 10:04:15 +0000 (GMT)
Message-ID: <55535704-ca32-483a-97e5-4d059294a9a3@linux.ibm.com>
Date: Thu, 30 Apr 2026 12:04:14 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] arm64/module, sframe: Add sframe support for
 modules
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-7-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260428183643.3796063-7-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=CIIamxrD c=1 sm=1 tr=0 ts=69f32923 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=YDQLautM2RPBGTTizU0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: BwPT5JYnQt3nKA7Nba_B9lCmuGb7WnjJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OCBTYWx0ZWRfX7X/1LldJi0xs
 5roC7bud/0ChxSIn9IEWxj++FwIyu5IL63F3vQDSocbluE7szCQUgAlV6jpoPT0BNuMo/biNQRd
 mZMfotz/xe14SYjL1y2UYinaJgjTsKClXa9o96LVTMPSQUZHHrIz8J139Qa+PXQTq7um6emfteK
 rGTojnzj78U3l9arEfMsjRJboa8i747nd78XZXjD7jVrgTQKLdFxsUQWg38gg/vsZyj87a1xbjp
 GNAPeTqVkg8+HfigFb8g3Bl4OCMmR4dt/nbbl657dXE3kvSv9K15AnnW7+IAQHiwWC3GHdzhWYX
 5Kq5LWQvFd/t8DuV7+XdVV4apTJIkvspZv0gPOm41NDhlDxV/j4HbtlUhjRHSMUuhdMSERBl/E/
 zVEe9GOvZ6ilywIdtA4HxpAhPea1hgPo029EHoGzlbHxUrgjI0WeNA4g1hanbDK/dPCebHaUq6I
 CvUjhvGiUijeOPtHOVQ==
X-Proofpoint-GUID: 8mFbwPJSfhxNg5qoftsVu3ev66yYtrOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604300098
X-Rspamd-Queue-Id: B2AB54A09DF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2614-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
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

On 4/28/2026 8:36 PM, Dylan Hatch wrote:
> Add sframe table to mod_arch_specific and support sframe PC lookups when
> an .sframe section can be found on incoming modules.
One small fix and a proposal to sort the module's SFrame FDE index.

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

A subsequent patch adds a call to sframe_validate_section(), which would
operate on the temporary struct sframe_section instance and thus fail
to use container_of() to access the struct module instance.  To resolve
change as follows:

> +void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
> +			void *text, size_t text_size)
> +{
> +	struct sframe_section sec;

	struct sframe_section *sec = &mod->arch.sframe_sec;

It is fine to initialize the module's struct sframe_section instance as
use of the information is guarded by mod->arch.sframe_init, which is
only set if the instance has been full initialized.

> +
> +	memset(&sec, 0, sizeof(sec));

Can be dropped if struct module instance got zero-initialized.

> +	sec.sec_type	 = SFRAME_KERNEL;
> +	sec.sframe_start = (unsigned long)sframe;
> +	sec.sframe_end   = (unsigned long)sframe + sframe_size;
> +	sec.text_start   = (unsigned long)text;
> +	sec.text_end     = (unsigned long)text + text_size;

Adjust all lines above to pointer access.

> +
> +	if (WARN_ON(sframe_read_header(&sec)))

Ditto.

> +		return;
> +
> +	mod->arch.sframe_sec = sec;

Drop.

> +	mod->arch.sframe_init = true;
> +}
Indu suggested that it would be preferable if a module's .sframe FDE
index table could be sorted during loading of the module to enable
binary search instead of having to resort to linear search.  I propose
to change this patch as follows to sort the module .sframe FDE index
table in sframe_module_init().  Note that the patch assumes above
changes have been implemented.  The sorting is very similar to sorting
of ORC tables in arch/x86/kernel/unwind_orc.c in unwind_module_init().

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
+#include <linux/sort.h>
 #include <linux/unwind_types.h>
 #include <asm/unwind_sframe.h>
 #ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
@@ -1038,6 +1039,50 @@ void __init init_sframe_table(void)
 	sframe_init = true;
 }
 
+static int sframe_sort_cmp_fde(const void *a, const void *b)
+{
+	const struct sframe_fde_v3 *fde_a = a, *fde_b = b;
+	unsigned long func_start_a, func_start_b;
+
+	func_start_a = (unsigned long)fde_a + fde_a->func_start_off;
+	func_start_b = (unsigned long)fde_b + fde_b->func_start_off;
+
+	return cmp_int(func_start_a, func_start_b);
+}
+
+static void sframe_sort_swap_fde(void *a, void *b, int size)
+{
+	struct sframe_fde_v3 *fde_a = a, *fde_b = b;
+	struct sframe_fde_v3 temp;
+	long delta;
+
+	/* Swap potentially unaligned FDE */
+	memcpy(&temp, fde_a, sizeof(struct sframe_fde_v3));
+	memcpy(fde_a, fde_b, sizeof(struct sframe_fde_v3));
+	memcpy(fde_b, &temp, sizeof(struct sframe_fde_v3));
+
+	/* Adjust FDE function start offset from FDE */
+	delta = (long)((unsigned long)fde_b - (unsigned long)fde_a);
+	fde_a->func_start_off += delta;
+	fde_b->func_start_off -= delta;
+}
+
+static int sframe_sort_fdes(struct sframe_section *sec)
+{
+	void *fdes = (void *)sec->fdes_start;
+	size_t num_fdes = sec->num_fdes;
+
+	if (sec->sec_type != SFRAME_KERNEL)
+		return -EINVAL;
+	if (sec->fdes_sorted)
+		return 0;
+
+	sort(fdes, num_fdes, sizeof(struct sframe_fde_v3),
+	     sframe_sort_cmp_fde, sframe_sort_swap_fde);
+	sec->fdes_sorted = true;
+	return 0;
+}
+
 void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 			void *text, size_t text_size)
 {
@@ -1053,6 +1098,8 @@ void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 
 	if (WARN_ON(sframe_read_header(sec)))
 		return;
+	if (WARN_ON(sframe_sort_fdes(sec)))
+		return;
 	if (WARN_ON(sframe_validate_section(sec)))
 		return;
 
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


