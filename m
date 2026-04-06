Return-Path: <live-patching+bounces-2307-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNIGIMYh1GlxrgcAu9opvQ
	(envelope-from <live-patching+bounces-2307-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 23:12:38 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C78C3A76E9
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 23:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E90FD304C7D1
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 21:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A1B386C25;
	Mon,  6 Apr 2026 21:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8qTvWxW"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D534312815
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775509944; cv=none; b=Dl5FTVt2quuVuTshNxhNJ+Y0XyzReH6hUFihYB20sApYNl686qIlc4X45LQq3D0zRj2JCr0T1+rSnfj+BiGpQho7HSUNzk/l1oyFqBco9djjVnbhKSfGNLeNqx08y08QQRquKEUB7YHq+0jE66U10RKktByN3wB1c5g4LAmmZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775509944; c=relaxed/simple;
	bh=l7vxEJgC+Ob793xoUL3efo8+VTg3EnXl8F+bVIOAC8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjlKtmZN143K/m9ap4klgw8MKOhXxEB2HMuAYRwhRetRIZ8oYkPe1QeBOgSxb9/8K6pOItOF0yZa/fXk7049SG9Nbtx3k5LtMeR2aabeMTmHyuxytMC6S+kMm/RGTI5RknwjMQ83TuG3QIcI1D1g6SVYCWLgXlfnzUwrOhY4ktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8qTvWxW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775509942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sknxFjh3PzCtxEMIhDuCr7zygcrbfejjCpqHKn1w+TQ=;
	b=h8qTvWxWlKGCeaPTh9IN5z/JvM6o4Cr3o1+gsFm5RBoBFR5pH2GXPnAwlpEapQerC4ORK3
	GZX+X/EANZLz6pf/WWkYGjwEHbHFLMgkLKMM42JJvenFe8sLf9FCWPTpim6FAtI8nldyDx
	nUztwLVv0QMEfuGdFQhZD86OdBKdSUg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-mXEQr5PIMhyg2dAXpnV_3w-1; Mon,
 06 Apr 2026 17:12:16 -0400
X-MC-Unique: mXEQr5PIMhyg2dAXpnV_3w-1
X-Mimecast-MFC-AGG-ID: mXEQr5PIMhyg2dAXpnV_3w_1775509933
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AB91195608B;
	Mon,  6 Apr 2026 21:12:12 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BAF31800576;
	Mon,  6 Apr 2026 21:12:06 +0000 (UTC)
Date: Mon, 6 Apr 2026 17:12:04 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>,
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org,
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to
 klp_patch
Message-ID: <adQhpBC2W9I6QW-g@redhat.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
 <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,google.com,kernel.org,suse.cz,suse.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2307-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2C78C3A76E9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 06, 2026 at 11:11:27AM -0700, Song Liu wrote:
> On Mon, Apr 6, 2026 at 4:08 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Sat, Apr 4, 2026 at 5:36 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Fri, Apr 3, 2026 at 1:55 PM Dylan Hatch <dylanbhatch@google.com> wrote:
> > > [...]
> > > > > IIRC, the use case for this change is when multiple users load various
> > > > > livepatch modules on the same system. I still don't believe this is the
> > > > > right way to manage livepatches. That said, I won't really NACK this
> > > > > if other folks think this is a useful option.
> > > >
> > > > In our production fleet, we apply exactly one cumulative livepatch
> > > > module, and we use per-kernel build "livepatch release" branches to
> > > > track the contents of these cumulative livepatches. This model has
> > > > worked relatively well for us, but there are some painpoints.
> > > >
> > > > We are often under pressure to selectively deploy a livepatch fix to
> > > > certain subpopulations of production. If the subpopulation is running
> > > > the same build of everything else, this would require us to introduce
> > > > another branching factor to the "livepatch release" branches --
> > > > something we do not support due to the added toil and complexity.
> > > >
> > > > However, if we had the ability to build "off-band" livepatch modules
> > > > that were marked as non-replaceable, we could support these selective
> > > > patches without the additional branching factor. I will have to
> > > > circulate the idea internally, but to me this seems like a very useful
> > > > option to have in certain cases.
> > >
> > >  IIUC, the plan is:
> > >
> > > - The regular livepatches are cumulative, have the replace flag; and
> > >   are replaceable.
> > > - The occasional "off-band" livepatches do not have the replace flag,
> > >   and are not replaceable.
> > >
> > > With this setup, for systems with off-band livepatches loaded, we can
> > > still release a cumulative livepatch to replace the previous cumulative
> > > livepatch. Is this the expected use case?
> >
> > That matches our expected use case.
> 
> If we really want to serve use cases like this, I think we can introduce
> some replace tag concept: Each livepatch will have a tag, u32 number.
> Newly loaded livepatch will only replace existing livepatch with the
> same tag. We can even reuse the existing "bool replace" in klp_patch,
> and make it u32: replace=0 means no replace; replace > 0 are the
> replace tag.
> 
> For current users of cumulative patches, all the livepatch will have the
> same tag, say 1. For your use case, you can assign each user a
> unique tag. Then all these users can do atomic upgrades of their
> own livepatches.
> 
> We may also need to check whether two livepatches of different tags
> touch the same kernel function. When that happens, the later
> livepatch should fail to load.
> 
> Does this make sense?
> 

I haven't been following the thread carefully, but could the Livepatch
system state API (see Documentation/livepatch/system-state.rst) be
leveraged somehow instead of adding further replace semantics?

--
Joe


