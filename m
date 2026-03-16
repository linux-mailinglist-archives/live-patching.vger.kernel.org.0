Return-Path: <live-patching+bounces-2210-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJm1GkxkuGlOdQEAu9opvQ
	(envelope-from <live-patching+bounces-2210-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:13:00 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E2AA02A0155
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C9F83019825
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 20:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF62A3ED5BE;
	Mon, 16 Mar 2026 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LoyQVflQ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A542264A7
	for <live-patching@vger.kernel.org>; Mon, 16 Mar 2026 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773691972; cv=none; b=lxuzzllNSg5zklRfxVKejYyRKiigs9JGcYPJCQMHnw/aZkCKPk2DWTiSIAm60Oiadvtiz2lPx5ntlCBY3Bq7oH/EAeuN9AJw9e8wdksNZmW0NAalHiFYmTUqpwc93r3+Cr7uoBGu3KRPHciHTGCvR99OUE2WOCiYP4l61b4jLkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773691972; c=relaxed/simple;
	bh=B1ZXfhdffSJR5UllIG7xSMLudvIuOdzjfWaUORTXvjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odm4gFsTo4UBn8sGWH8d9SIW1/iKsJ3u/+gUN90SwwcfIIrzYU59dVAyAbUL44h7o5DpD0B3RMR55juJH0Lg1w5N917mYLWw0juYmwTPoRLOGCpQTButVThmLAiLVHK+K3f+GQYjv3lMFN9TEWAr0f5rrGZ4KcGDIwpPggXvgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LoyQVflQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773691970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGljA4uILLKFhtcR+6r6n0BSLyAdCgRwO5WiOXFsz4c=;
	b=LoyQVflQ9neAvciH+Erk1I/Ob3JDrH/PO7pDV7ODnYDDg7XK6D85FvH8egmGD49xMPKPKq
	Qk80Bx1vR83t9eWVYs5WDrJJoJiD6ebyjXlK3hFKXjMBocYVl5fOuUf8iI94bDfB4kVZ1Y
	rgH+HgxUT+3pkGvi/GPkaD1tySmqpxI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-2y0VBO6GM7i6QVcEhUf7nQ-1; Mon,
 16 Mar 2026 16:12:46 -0400
X-MC-Unique: 2y0VBO6GM7i6QVcEhUf7nQ-1
X-Mimecast-MFC-AGG-ID: 2y0VBO6GM7i6QVcEhUf7nQ_1773691965
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1695B195609D;
	Mon, 16 Mar 2026 20:12:45 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53998180075C;
	Mon, 16 Mar 2026 20:12:42 +0000 (UTC)
Date: Mon, 16 Mar 2026 16:12:38 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
Message-ID: <abhjYtyveer4niGM@redhat.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2210-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E2AA02A0155
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 13, 2026 at 05:58:32PM -0300, Marcos Paulo de Souza wrote:
> Instead of checking if the architecture running the test was powerpc,
> check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.
> 
> No functional changes.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> index dd802783ea849..c01a586866304 100644
> --- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> @@ -12,15 +12,14 @@
>  #include <linux/slab.h>
>  #include <linux/livepatch.h>
>  
> -#if defined(__x86_64__)
> +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> +#define FN_PREFIX
> +#elif defined(__x86_64__)
>  #define FN_PREFIX __x64_
>  #elif defined(__s390x__)
>  #define FN_PREFIX __s390x_
>  #elif defined(__aarch64__)
>  #define FN_PREFIX __arm64_
> -#else
> -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> -#define FN_PREFIX

The patch does maintain the previous behavior, but I'm wondering if the
original assertion about ARCH_HAS_SYSCALL_WRAPPER on Power was correct:

  $ grep ARCH_HAS_SYSCALL_WRAPPER arch/powerpc/Kconfig
          select ARCH_HAS_SYSCALL_WRAPPER         if !SPU_BASE && !COMPAT
          depends on PPC64 && ARCH_HAS_SYSCALL_WRAPPER

Perhaps I just forgot what that additional piece of information that
explains the comment (highly probable these days), and if so, might be
nice to add to this commit since I don't see it in 6a71770442b5
("selftests: livepatch: Test livepatching a heavily called syscall").

Thanks,
--
Joe


