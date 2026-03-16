Return-Path: <live-patching+bounces-2211-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uM1mNqNquGn5dgEAu9opvQ
	(envelope-from <live-patching+bounces-2211-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:40:03 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4340C2A04A6
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 21:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A923300C009
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 20:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735B539183E;
	Mon, 16 Mar 2026 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRBJ/w7t"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8EE359FB0
	for <live-patching@vger.kernel.org>; Mon, 16 Mar 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773693521; cv=none; b=CF2li4bQXGD6sYiWc89Xipc2ftUIRWyauCeCa3nERKywjqgMJ3m5ghgvZStY/p0RcbhhpXQ+puQ4YDb+XDGlrODI6OIu+1UrZAiKRqDm8GRvU3BVzWtTs8coPzsRUS/Ur7X1Jjlh9wIrzDOsWXrnoh+XMKfPP70SJ1WYBITOFkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773693521; c=relaxed/simple;
	bh=HaggyQjHOfgzxcCADMxxd3tw5ezilB9mJQAhnwH9ZB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+C4PU4y4PNlDCgrwoThC5qmXvwwlI4cxvNVab1sQYKuKB74Qso0P9IwoqNn029PRRnEclQwPhptOA8VkC/VMdHePkRk2dPuviQmC3goRi2fRed50rdwVY1PzZGmKRaOIqS/kzpL2ZXdUr3qo1U98Cck5PDGTDNffX2X2MTQu5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRBJ/w7t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773693518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DWqmjuWF70znpZxm47ikMW1Pcmq6K7FsNzZd5IofOT0=;
	b=FRBJ/w7theUnqwXCU4EfIHp774AwYSrpz8bOZis3nMNMFFD6WwlJAiJRWJyyM1tyWEk+WN
	KVtu6YMOoaWJnAu2RDqD3F7n4NNg3dWQhZNgQ4f4TarPTgJk3e9PFboe8kVqv+WNEB7aoC
	gukyOF359PLMVnjFTHVI8qcGIh5fGro=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-XM390azuPS6lGnKv9xsxQQ-1; Mon,
 16 Mar 2026 16:38:37 -0400
X-MC-Unique: XM390azuPS6lGnKv9xsxQQ-1
X-Mimecast-MFC-AGG-ID: XM390azuPS6lGnKv9xsxQQ_1773693515
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D48B195605E;
	Mon, 16 Mar 2026 20:38:35 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.140])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C58F71955F19;
	Mon, 16 Mar 2026 20:38:32 +0000 (UTC)
Date: Mon, 16 Mar 2026 16:38:29 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] selftests: livepatch: test-kprobe: Check if kprobes
 can work with livepatches
Message-ID: <abhqRTBtF1hLDmPq@redhat.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-3-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-3-71ac6dfb3253@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-2211-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 4340C2A04A6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 13, 2026 at 05:58:34PM -0300, Marcos Paulo de Souza wrote:
> Running the upstream selftests on older kernels can presente some issues
> regarding features being not present. One of such issues if the missing
> capability of having both kprobes and livepatches on the same function.
>

nit picking, but slightly reworded for clarity and spelling:

Running upstream selftests on older kernels can be problematic when
features or fixes from newer versions are not present. For example,
older kernels may lack the capability to support kprobes and livepatches
on the same function simultaneously.

> The support was introduced in commit 0bc11ed5ab60c
> ("kprobes: Allow kprobes coexist with livepatch"), which means that older
> kernels may lack this change.
> 
> The lack of this feature can be checked when a kprobe without a
> post_handler is loaded and checking that the enabled_function's file
> shows the flag "I". A kernel with the proper support for kprobes and
> livepatches would presente the flag only when a post_handler is

nit: s/presente/present 

> registered.
> 
> No functional changes.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/test-kprobe.sh | 52 ++++++++++++++----------
>  1 file changed, 31 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
> index cdf31d0e51955..44cd16156dbd4 100755
> --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> @@ -16,30 +16,19 @@ setup_config
>  # when it uses a post_handler since only one IPMODIFY maybe be registered
>  # to any given function at a time.
>  
> -start_test "livepatch interaction with kprobed function with post_handler"
> -
> -echo 1 > "$SYSFS_KPROBES_DIR/enabled"
> -
> -load_mod $MOD_KPROBE has_post_handler=1
> -load_failing_mod $MOD_LIVEPATCH
> -unload_mod $MOD_KPROBE
> -
> -check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=1
> -% insmod test_modules/$MOD_LIVEPATCH.ko
> -livepatch: enabling patch '$MOD_LIVEPATCH'
> -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> -livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
> -livepatch: failed to patch object 'vmlinux'
> -livepatch: failed to enable patch '$MOD_LIVEPATCH'
> -livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
> -livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> -livepatch: '$MOD_LIVEPATCH': unpatching complete
> -insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Device or resource busy
> -% rmmod test_klp_kprobe"
> -
>  start_test "livepatch interaction with kprobed function without post_handler"
>  
>  load_mod $MOD_KPROBE has_post_handler=0
> +
> +# Check if commit 0bc11ed5ab60c ("kprobes: Allow kprobes coexist with livepatch")
> +# is missing, meaning that livepatches and kprobes can't be used together.
> +# When the commit is missing, kprobes always set IPMODIFY (the I flag), even
> +# when the post handler is missing.
> +if grep --quiet ") R I" "$SYSFS_DEBUG_DIR/tracing/enabled_functions"; then

Will flags R I always be in this order?

--
Joe


