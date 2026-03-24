Return-Path: <live-patching+bounces-2254-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OH3QEOSkwmkyggQAu9opvQ
	(envelope-from <live-patching+bounces-2254-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 15:51:16 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD42430A7B9
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 15:51:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45E2E311C72E
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 14:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A93C3890ED;
	Tue, 24 Mar 2026 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixHkTv3Z"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A89D38550B
	for <live-patching@vger.kernel.org>; Tue, 24 Mar 2026 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363529; cv=none; b=gOFK5RDA2PYsyqjs7gywCLDnbLgUwGQsYkzKNasy1yUVevhxzIRQjF7rWgvEpIvY4Piud6Zi3oSlvizUJevQOh0BhnERH/8UWDr8LL5dO6neUUYapDp8I8d4aoXSA1arDudxLd3OVsig3iZi37TfIl+YdiqV57bLMVLsmDM8Jyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363529; c=relaxed/simple;
	bh=vZTTPEIYuiOXV35Y1qrnUhKegm4CjyqZBzMLEa3WqGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BasoQjVV8iT0kUeNUSjreGqH7o+bd9BzY/8EZ7/lsflbNJmA8Q2u3UfOiOnJM4j4lu//FVwJTKU1oauuSc6K+a6xxY0CLTXZ8j/d2LZW0QllCFO247dDw2cpuXDw6POpL7xYaS9D1IrJF096nbkP5LHLtxnX6VV2nn3jvMJD9OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixHkTv3Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774363526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7zExN/z3Izup7m2aGhIzPxY/KEcJ3LRPb1fPMVoA6wg=;
	b=ixHkTv3Z6Bomih0DhddyU/KBY3FhhhrjhqERf4A2CgmSy4KzoJn+GBXtWdJz/b03IaqGnD
	O0jqsKEn2VkbV7EHwmnoH+Y1VdyiHQu6cwAWpDVPykKu1PtITIPJC9+7qXPR+S+vCHGA8v
	h4nYk8qzuEcHUNfraUEVjiz+JMToeks=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-i-ME23UrMY-z1CO1Rqd8gw-1; Tue,
 24 Mar 2026 10:45:21 -0400
X-MC-Unique: i-ME23UrMY-z1CO1Rqd8gw-1
X-Mimecast-MFC-AGG-ID: i-ME23UrMY-z1CO1Rqd8gw_1774363519
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C48C1944EB8;
	Tue, 24 Mar 2026 14:45:19 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.124])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACF5E1800107;
	Tue, 24 Mar 2026 14:45:17 +0000 (UTC)
Date: Tue, 24 Mar 2026 10:45:15 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Pablo Hugen <phugen@redhat.com>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
	shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
Message-ID: <acKje1XMQMQQYBIL@redhat.com>
References: <20260320201135.1203992-1-phugen@redhat.com>
 <177436214729.62466.7977538958560300344.b4-review@b4>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177436214729.62466.7977538958560300344.b4-review@b4>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2254-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,test-callbacks.sh:url]
X-Rspamd-Queue-Id: AD42430A7B9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 24, 2026 at 03:22:27PM +0100, Miroslav Benes wrote:
> On Fri, 20 Mar 2026 17:11:17 -0300, Pablo Hugen <phugen@redhat.com> wrote:
> > Add a target module and livepatch pair that verify module function
> > patching via a proc entry. Two test cases cover both the
> > klp_enable_patch path (target loaded before livepatch) and the
> > klp_module_coming path (livepatch loaded before target).
> 
> We sort of test the same in test-callbacks.sh. Just using different
> means. I think I would not mind having this as well.
> 
> Petr, Joe, what do you think?
> 

I was *just* in the middle of replying to the patch when yours came in,
so I'll just move over here.  I had noticed the same thing re:
test-callbacks.sh despite originally suggested writing this test to
Pablo (and forgot about the callbacks test module).  With that, I agree
that it's a nice basic sanity check that's obvious about what it's
testing.

> >
> >
> > diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> > new file mode 100644
> > index 000000000000..9643984d2402
> > --- /dev/null
> > +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> > @@ -0,0 +1,39 @@
> > [ ... skip 11 lines ... ]
> > +
> > +static noinline int test_klp_mod_target_show(struct seq_file *m, void *v)
> > +{
> > +	seq_printf(m, "%s: %s\n", THIS_MODULE->name, "original output");
> > +	return 0;
> > +}
> 
> A nit but is 'noinline' keyword needed here? proc_create_single() below
> takes a function pointer so hopefully test_klp_mod_target_show() stays
> even without it?
> 

No strong preference either way.  I won't fault a livepatch developer
for being paranoid w/respect to the compiler :D

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
--
Joe


