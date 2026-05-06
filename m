Return-Path: <live-patching+bounces-2737-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oA5/GJ8W+2lGWgMAu9opvQ
	(envelope-from <live-patching+bounces-2737-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 12:23:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BAC4D9488
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 12:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5587A30065D3
	for <lists+live-patching@lfdr.de>; Wed,  6 May 2026 10:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3783EC2EA;
	Wed,  6 May 2026 10:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZPvEcp/6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4828F3BE65F
	for <live-patching@vger.kernel.org>; Wed,  6 May 2026 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778063004; cv=none; b=BMIoGCOxTiGyvZrX+OmEOBsJ3aI1C9fDfS5Ovu6YW6VNmOEqtexJcGlB37ifSfLxy8Cqjp2j4ZDR683pV+J7RVAsDWyhnQ5ODO5F/hL5GEkWQ8qhNwXVJne8m7ZLIqA9xUqipKkGcXwK2F1YaHm31TvyR01YrDUWJA74WxFKZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778063004; c=relaxed/simple;
	bh=hE1y4kmNtGeYAv67zS4+OoQ1t7uYKSkNfK3zwD7Fhf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlWvHkPgikykn8Eng+UCaKiilgJEW7ogmlZjNcZPXQ2zTseGdmQGbBfs7TtbskIS6MaTGzKAv6gTThRS+d8dyFWneYKunPyyyWpFU8hkXlcgEP58yCJ4s6np+2/sxsTIBvkPG5h909rBSJzGRPmC8GWRoqNvE1NeleaMpctmOtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZPvEcp/6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48d146705b4so22452895e9.3
        for <live-patching@vger.kernel.org>; Wed, 06 May 2026 03:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778063002; x=1778667802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vyuimllbRFDBrd/zLQpQ1lykL+0Cgk5rh3xGvQeZlAE=;
        b=ZPvEcp/62ZAHSPf2QDKAPjNrHySVflsqlrZZ8OXvPdUriXEvRw6bTaXNH8loYHVPp/
         rf76WZJna/Mug6AoLTDveLq0uqpbUTcoDP4K/1XoA/fG4x9l3Sos9pdRDWF4ZOW0Dx3p
         KHZHAYg/zfvDccOc9vkpiHLS8Hy+bTVSrLk0ZngH//OG20vzq9UxRUfcJGlbnIWzSC9a
         1sJoezSs7XxI1FrLI787Dohn8cgRSIec38RwztDPGObygdtYXi6tKtdDP9nmhQEeTWuK
         DqPnqDRDMXfZ7eHVNI+OleIeYTOIZwdGz/Ff9gA9SZYAvkWtpwoVrcM5cdH51DeR0GKT
         wu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778063002; x=1778667802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyuimllbRFDBrd/zLQpQ1lykL+0Cgk5rh3xGvQeZlAE=;
        b=T+qvBCR2o5KxQ42g1BybXFMAXOQonxX+If6b8kKG/8jru/sA3nowfZ5FzaJfAZ8Nx5
         51cjWdMI9rvjUDs3335mg6xZV0whhfhFk56D/CiU7QzNFdIRvN+BQdrzb6oawoPBBDIF
         pgY4M6rSXDE/dbtKoitGULDAfigqtfEAxXopcp6/xSWYHJF4WMVCO1EqkQQTetiPc5IV
         M0O+WKUbwYLgET3CCCWvIBGr8s7+Ys6OWQhRCZmd8xDAUpJj3Agr7Aw65qhvfb3+ZqSz
         Ash1pXxGVGODlzICA0PJP+KaaFTEhXJWx0lQ3mVJkSeTkrL1XYuD03GVE5n5JenOxyMn
         UcNg==
X-Forwarded-Encrypted: i=1; AFNElJ8M0E6W/+UW3x+6pdF4aJTxBTeNZR0k+EGTJlnb8U0EZRglSKlliYVt2cY8xCsFU78TH/eTa/bnXRs01T5g@vger.kernel.org
X-Gm-Message-State: AOJu0YyU/nAqgqWr1nBVFAnIoDiZpTh801R2aXDs5UdeXfwhhg2fhcYb
	uOlUHTYYtxWaRtMzHHqthMj0VUDZTX83ONEaryQMGnNXXPsdnDGO9NgUI/julNz1Jyw=
X-Gm-Gg: AeBDiev7kbFr7IOWRSHFBM84ihDcVfqLFkwnNREFABZi8gCDR8MF8D2BXxnHkNa2pyR
	fbc03nY0YZE/9UzL8MKWLiEHbMveSTiDyId9q+o8jGcyo75t6bZ0wdMyQDiZsOdYScJw2ZYMauu
	DfrmWxbFMxx+WLV2rlCAnuksnO7ym41+iVipt7eiS13Vn2fwx7oBaxWrIZ+yNO/yBx8GEnqhbXV
	5XMMvvTtOMm96rKrf7YTAAAhUMQgpBBezPP/tfjCcxq/R6ew0kZcV1EhKuxZia7OkxAa2ozskSA
	AWk17YDuP00BeVBDoeno9aleUIbM25qmbhUbB9GmFaHamDRTmI7G0fUG5Bfa2xY1/mgTlOwbs/q
	CBtcaFQ9h3IL0zd13Lyk9JgsYmNoDvsBeSoTqUrIhQj1daiM1/rv+sgWI+oYgeawG0uSczqmcVo
	A4MmcqnFyl4JY28OTVnisHlm8Yq895wvtBRBq5
X-Received: by 2002:a05:600c:c48f:b0:48a:568f:ae6b with SMTP id 5b1f17b1804b1-48e51f2a790mr50341575e9.7.1778063001669;
        Wed, 06 May 2026 03:23:21 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538ca8c0sm35025085e9.13.2026.05.06.03.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 03:23:20 -0700 (PDT)
Date: Wed, 6 May 2026 12:23:18 +0200
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	marcos@mpdesouza.com
Subject: Re: [PATCH v5 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Message-ID: <afsWlkqDboHezQ5R@pathway.suse.cz>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
X-Rspamd-Queue-Id: F0BAC4D9488
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2737-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email]

On Mon 2026-05-04 15:34:41, Marcos Paulo de Souza wrote:
> This is the fifth version of the patchset, which fixes the last Sashiko
> comment, about overwriting MOD_LIVEPATCH global variable and using a
> local variable to avoid module load clashing when an older kernel
> don't support some sysfs attributes.
> 
> Original cover-letter:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
> 
> ---
> Marcos Paulo de Souza (6):
>       selftests: livepatch: Check for ARCH_HAS_SYSCALL_WRAPPER config
>       selftests: livepatch: Replace true/false module parameter by y/n
>       selftests: livepatch: Introduce does_sysfs_exist function
>       selftests: livepatch: Check if patched sysfs attribute exists
>       selftests: livepatch: Check if replace sysfs attribute exists
>       selftests: livepatch: Check if stack_order sysfs attribute exists
> 
>  tools/testing/selftests/livepatch/functions.sh     |  10 +
>  tools/testing/selftests/livepatch/test-kprobe.sh   |   8 +-
>  tools/testing/selftests/livepatch/test-sysfs.sh    | 219 +++++++++++----------
>  .../livepatch/test_modules/test_klp_syscall.c      |  27 ++-
>  4 files changed, 153 insertions(+), 111 deletions(-)

For the entire patchset:

Reviewed-by: Petr Mladek <pmladek@suse.com>

It seems to be ready for linux-next.

Best Regards,
Petr

