Return-Path: <live-patching+bounces-2246-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMZPMqtHvWlr8gIAu9opvQ
	(envelope-from <live-patching+bounces-2246-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:12:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 410ED2DAC1E
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A67F301842B
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802323B8BAE;
	Fri, 20 Mar 2026 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MHQk18xd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F4B3A9DA4
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774012328; cv=none; b=lWtVYaQKx32ULZKrrwYRmlfglg1GNdV6JxdoZt64ZgVNJdNF1/EFBymfovbFseUNOp/bqH7YBMkA5u1CAW2KBxSN62VFNLjeCibqzycTbi+mQeur3K8Zss98ygfD0j9R2SDM30zrKaIDHSbVuLpOk1ty9LZVrOnKoV/cg40FvlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774012328; c=relaxed/simple;
	bh=i0a09aXhOP/QlBqzizvEoGUl0WgcS81yzRiwfsaclx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilYQ6Y8tLcg/+yn67DP4OIbMYh7orD+olwHnGSoQkTc8XkAxx+A2HxfiHA8hGkuWHJywWHlT7ZdShR0PL63f59bOSAWfgcsrYRSFdUkKUlc6KU3lpzkg4mxSCrT1KTeKXOV3mkWyjizrNpfr9ijTf4QvRDxy7mrLFxn5y0ISKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MHQk18xd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so5092305e9.1
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 06:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774012325; x=1774617125; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XuiKHSkZ3E5unJ4q4dyvIHV5c5AfIhyVuPpE5qhhaFU=;
        b=MHQk18xddch3LA4u1Cq/Am55SsN1zw+h8A1Kq5NvvDvpg8CNhe9JWX58dZZk+oz/XX
         YoZiJfLPPv+a3veMOjiTwgVBmlVTugxKMa9ULfk0Kd08CvljTlOQSGp2SocShfwCSFCy
         /eLlm+HT4Kt6MFtlqePMIcqy7aJnm+jD6V8dKhvp1fUuzdpXtbehqr2G4+0BZapeLOD6
         bS2KtvHcWSvxgHeXXtPFm2334SBHKR20ztjsfMQY+MxJxyi7Pz+znAaxZWONaFkA9+PP
         Zc0e4PKBFJZVgFIoIBkNRC4iLRph9yRRM4el9OD1uYBZ7i+s3XXhzlanuv5obDdnt1ta
         5vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774012325; x=1774617125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XuiKHSkZ3E5unJ4q4dyvIHV5c5AfIhyVuPpE5qhhaFU=;
        b=Qj4FPOp1kRkNQOLC5WxSGxkjcj6mDLIeAB/lyGhnLqR54nrtNXUWdF6KF6g2KqvRSo
         Ms+PIT4YMUZCwdrjrvN0ZLhR/c35UX3Qk9hqfwBFiqCnilcS/UXzfhPr4O7mH0YEIa3F
         WuDTRkhuHEwGGeCpAyrGFil7myPC3GxmIk3Q1nQ2sOiJQfzBCh5LHFBcBiEiyuKN74LJ
         InjrRVFGgQZQzC/4BefR+T39m0GveYV2JdCruCPKeqKsskqTuZWJxR0Xv36+KteI1QHA
         o9UcpBpYz5FU9KIxVnnofp3z8Tojl174jj1K2ef81Kia8axodTOVfBH0Ra+8Zt7XsMIz
         VJug==
X-Forwarded-Encrypted: i=1; AJvYcCVOi3seFQRUkCestRjNJNHHjAbsB7CYPwQBr2mOf3+wuAAXByrEa3ByvXzo85TEx/PoC5jrivTCdjbadciB@vger.kernel.org
X-Gm-Message-State: AOJu0YwYluNIO+h/7xefUURtaslFH6h10rzGwdtmGeYuPQdAqCyN+OTI
	ThjgZ/rmgxM/P2xVZoHFV4zVcs0F//yJ2sMOhrTSrO030S+pdGM+Ao+WqJW93ecLy3o=
X-Gm-Gg: ATEYQzxee9c3DbvRgyWJzfF2LglY7BFRRecmEiRzkK7xhxERnxX6FCyNGS3zMn80WRD
	sz0fQSOWmPlmMvV6rkZuhRAm5xXvBXMkJxvzeESwAXTk4eYlivPC5j6qI3Q8K95ZGY6x4fGAnpR
	lgAE7ZXpzXl0AqQdQY1vveWMz+mVIqIuPsDEyMDyVO2ccA5O9brqP94nYv2HHPRG7ou+B90pG6u
	FXjF9tgggUQOKNs9+qShXIa7cCbiw6uE3fHZHBnt+R0dPdNuW0v3iYoTKt5Zub21KXEgLiLEvvG
	yH2/kCuh1cy3KTxI52Hgi8pW6SQW6yqKbXjenUTje1Hh+E6/Ny6GA1rY5eXU4d1AOAoto3S94gC
	sZcof8JXOHUbiEQiM/3d88G2F5dN6X+jVie0y3frimMJ6NWfB9TJVpHEbHytq8KF+gmFwWAn5rK
	f/21Cdv4L2Sftg+6fyY7vPOH+yYA==
X-Received: by 2002:a05:600c:3e16:b0:486:fad0:b166 with SMTP id 5b1f17b1804b1-486fee0b74emr47326835e9.17.1774012325282;
        Fri, 20 Mar 2026 06:12:05 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64703c27sm6624281f8f.18.2026.03.20.06.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 06:12:04 -0700 (PDT)
Date: Fri, 20 Mar 2026 14:12:03 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] selftests: livepatch: sysfs: Split tests of replace
 attribute
Message-ID: <ab1Ho0jqOhFu3KZn@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-5-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-5-71ac6dfb3253@suse.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2246-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[test-state.sh:url,test-sysfs.sh:url,suse.com:dkim,suse.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 410ED2DAC1E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri 2026-03-13 17:58:36, Marcos Paulo de Souza wrote:
> In order to run the selftests on older kernels, split the sysfs tests to
> another file, making it able to skip the tests when the attributes
> don't exists.
> 
> No functional changes.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/Makefile         |  1 +
>  .../selftests/livepatch/test-sysfs-replace-attr.sh | 75 ++++++++++++++++++++++
>  tools/testing/selftests/livepatch/test-sysfs.sh    | 48 --------------
>  3 files changed, 76 insertions(+), 48 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
> index a080eb54a215d..b95aa6e78a273 100644
> --- a/tools/testing/selftests/livepatch/Makefile
> +++ b/tools/testing/selftests/livepatch/Makefile
> @@ -10,6 +10,7 @@ TEST_PROGS := \
>  	test-state.sh \
>  	test-ftrace.sh \
>  	test-sysfs.sh \
> +	test-sysfs-replace-attr.sh \
>  	test-syscall.sh \
>  	test-kprobe.sh
>  
> diff --git a/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh b/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh
> new file mode 100755
> index 0000000000000..d1051211fe320
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh
> @@ -0,0 +1,75 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 Song Liu <song@kernel.org>
> +
> +. $(dirname $0)/functions.sh
> +
> +MOD_LIVEPATCH=test_klp_livepatch
> +
> +setup_config
> +
> +# - load a livepatch and verifies the sysfs replace attribute exists
> +
> +start_test "check sysfs replace attribute"
> +
> +load_lp $MOD_LIVEPATCH
> +
> +check_sysfs_exists "$MOD_LIVEPATCH" "replace"
> +file_exists=$?
> +
> +disable_lp $MOD_LIVEPATCH
> +
> +unload_lp $MOD_LIVEPATCH
> +
> +if [[ "$file_exists" == "0" ]]; then
> +	skip "sysfs attribute doesn't exists."

Nit: I would write "is not supported by this kernel version"
     instead of "doesn't exist".

     I think that it better describes the situation.
     "doesn't exist" sounds more like an error description.

> +fi

This extra code is repeated in 6th and 7th patch as well.
It would be nice to hide it into some helper function
so that we could use here something like:

	check_sysfs_attr_or_skip "replace"

or

	if has_klp_sysfs_attr "replace" ; then
		skip "sysfs \"replace\" attribute is not supported"
	fi

Best Regards,
Petr

