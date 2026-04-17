Return-Path: <live-patching+bounces-2389-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCdJO4144mnh6AAAu9opvQ
	(envelope-from <live-patching+bounces-2389-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:14:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CA941DE1B
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B4D6E30010C9
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 18:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AAE3B2FD9;
	Fri, 17 Apr 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gp8q83z9"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1361830E85D
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776449674; cv=none; b=fWgi2OzPXjl/ekqiU8SJcIgqdyBTXc+AcFITch+gofNaIb1RSGMDAbfn0neaKrn7PSr/yImvtCSofWCnw/tDIGo69IGuksxHjKDUIcoYuhch7vrLGKQMnDLrN4JGFfV7spMQb1smpnUceNdtqgI/FqFR8ZU1wtbiRsyh8hxoHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776449674; c=relaxed/simple;
	bh=kqWN9cquGSmH9IXIQV7Nr2zvMl3NniRqSCtzpGxBUQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jz/lxUOhxvgQX8Iuz+xDITHrwhKrp2PI7Mt3E1UtSuERNMK9IzZUKGrnJ6udfjOfwZXQwn6TK2+1gTl7ScrXU5Y4U8WFYuE9JgZk9ikTQSd+N0ip1EDoPn0N1hADFX2ZMCpc5MGGBy8p9vAPHqkA9Wz3jVD8sDXBYKiLTeq3TzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gp8q83z9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776449663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gr8Z/t3otNTOcOWm4td0wFpr2VHtxnmcGo0baYrQfBw=;
	b=Gp8q83z9Lqy5MQq/DSxcjv548sMsbVXWIDP9IOcDv41bTjL0QRMdpijdEIONS1kpf3cHTF
	hAHSRf5IVI5yejE2YFESIeoE9aEqy9H81EV/RPcICod/PsTbVVEKS1Cb5t32jcm3yNyUc+
	VOCwI+yxEpKUA3/mxUyUvFMsjElcaJ4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-ByJQGDcbNien7yxC_RKbpQ-1; Fri,
 17 Apr 2026 14:14:19 -0400
X-MC-Unique: ByJQGDcbNien7yxC_RKbpQ-1
X-Mimecast-MFC-AGG-ID: ByJQGDcbNien7yxC_RKbpQ_1776449658
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FE3019560B7;
	Fri, 17 Apr 2026 18:14:18 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0DF8180047F;
	Fri, 17 Apr 2026 18:14:16 +0000 (UTC)
Date: Fri, 17 Apr 2026 14:14:14 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Message-ID: <aeJ4djfEdg3EfiBK@redhat.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
 <20260413-lp-tests-old-fixes-v2-1-367c7cb5006f@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413-lp-tests-old-fixes-v2-1-367c7cb5006f@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2389-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 92CA941DE1B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 13, 2026 at 02:26:12PM -0300, Marcos Paulo de Souza wrote:
> Older kernels that lack CONFIG_ARCH_HAS_SYSCALL_WRAPPER config don't
> have any prefixes for their syscalls. The same applies to current
> powerpc and loongarch, covering all currently supported architectures
> that support livepatch.
> 
> The other supported architectures have specific prefixes, so error out
> when a new architecture adds livepatch support with wrappes but didn't

nit: s/wrappes/wrappers

> update the test to include it.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  .../selftests/livepatch/test_modules/test_klp_syscall.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> index dd802783ea84..b5527a288a7c 100644
> --- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> @@ -12,15 +12,26 @@
>  #include <linux/slab.h>
>  #include <linux/livepatch.h>
>  
> -#if defined(__x86_64__)
> +/*
> + * Before CONFIG_ARCH_HAS_SYSCALL_WRAPPER was introduced there were no
> + * prefixes for system calls.
> + * Both ppc and loongarch does not set prefixes for their system calls either.

nit: s/does not/do not

--
Joe


