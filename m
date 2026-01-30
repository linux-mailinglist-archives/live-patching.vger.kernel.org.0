Return-Path: <live-patching+bounces-1949-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK+9Fq82fWkuQwIAu9opvQ
	(envelope-from <live-patching+bounces-1949-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:54:39 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5666BF3EB
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BC178300460E
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 22:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCB935B130;
	Fri, 30 Jan 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ip6CFHds"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB00135A95C
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813674; cv=none; b=m4nGGOO6ry61948331E1O4rmY8x8MYYQH/pxqrl36cfJfbeo1Fl0ba4G8PbHDT64bNacnHAx97BFu+Aws04VGcr5KWci6K64t+kEuZxYPmzM+lQWg3lRCp+ne2Tv0Tmbf8QAagG8YnNI0yCZN4UCq9dslewdIwViIGgLQdHorH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813674; c=relaxed/simple;
	bh=af358eE0Zd0ysQ5h2JIOD5/aVhRx0B7itNmPJ9DUEFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZH/yO12CsQV2kwGrtOUmtFi5xnZ6kwHWavvFnDv8b+Yu+eOxSVUClrEQ52QCu3BT9d5SJmvvEo0XfrL7M2n4NfEze0XECUGZRa0swXJTTnEO+KU+Q8h5MoPI8JFXPjr42yroU/Uq9Qm6pzmyef67+T5IIXlSV8BtpeZ4Bl4R94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ip6CFHds; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEA0C4CEF7;
	Fri, 30 Jan 2026 22:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769813674;
	bh=af358eE0Zd0ysQ5h2JIOD5/aVhRx0B7itNmPJ9DUEFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ip6CFHdsEj2j16T1hVZfhzip/PRC9BuSJgR8sMGrUv3VvgspKa7/7x2fKcIJS4Mod
	 9JQwyTFV0ludYqgUPzsn8svpnQ5igMJ8I4FQJ+kNGqPa+xIWRLlktnTsLGLM5oubQm
	 ydYxIZ0UtXFfNlLPKGf1+l2c+FeE1rH82ee9I9VGlXNSonSgjTelpfBuBoPxG5aK/k
	 Sq1lKQrxSAfAcWMWqXfYiDy1QHz0Aycr2KdHgJN9PTQZH9GJYzzrajMyeOO4Gg9UW9
	 ScAJpeukBH4ldT2T8W9iX8AtLN5IcSCdmjFovC/36LYfgIoMVjmRLcSMFLcTM2j8Ax
	 QwWGb0aeRUG6g==
Date: Fri, 30 Jan 2026 14:54:32 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <47mvnqxh6mc6twwmkrcfmmhnyo3ujsab6tkotvuf2jmsupveib@sf65ms5pp4de>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
 <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
 <aX0RBzV5X1lgQ2ec@redhat.com>
 <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1949-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E5666BF3EB
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:46:19PM -0800, Song Liu wrote:
> On Fri, Jan 30, 2026 at 12:14 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> > On Fri, Jan 30, 2026 at 11:58:06AM -0800, Song Liu wrote:
> > > On Fri, Jan 30, 2026 at 10:00 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > > [...]
> > > > @@ -807,6 +906,8 @@ build_patch_module() {
> > > >  process_args "$@"
> > > >  do_init
> > > >
> > > > +maybe_rebase_patches
> > > > +
> > > >  if (( SHORT_CIRCUIT <= 1 )); then
> > >
> > > I think we should call maybe_rebase_patches within this
> > > if condition.
> > >
> >
> > Hi Song,
> >
> > Ah yeah I stumbled on this, probably overthinking it:
> >
> >   - we want to validate rebased patches (when requested)
> >   - validate_patches() isn't really required for step 1 (building the
> >     original kernel) but ...
> >   - it's nice to check the patches before going off and building a full
> >     kernel
> >   - the patches are needed in step 2 (building the patched kernel) but ...
> >   - patch validation occurs in step 1
> 
> Hmm.. I see your point now.
> 
> > so given the way the short circuiting works, I didn't see a good way to
> > fold it in there.  The user might want to jump right to building the
> > patched kernel with patch rebasing.  Maybe that's not valid thinking if
> > the rebase occurs in step 1 and they are left behind in klp-tmp/ (so
> > jumping to step 2 will just use the patches in the scratch dir and not
> > command line?).  It's Friday, maybe I'm missing something obvious? :)
> 
> Maybe we should add another SHORT_CIRCUIT level for the validate
> and rebase step? It could be step 0, or we can shift all existing steps.

I don't see how that solves the problem?  For --short-circuit=1 and
--short-circuit=2 we still want to validate and rebase the patches
because they are used in step 2.  But as Joe mentioned, that can be done
before step 1 to catch any patch errors quickly.

Something like this?

if (( SHORT_CIRCUIT <= 2 )); then
	status "Validating patch(es)"
	validate_patches
	fix_patches	# including fixing fuzz???
fi

if (( SHORT_CIRCUIT <= 1 )); then
	status "Building original kernel"
	clean_kernel
	build_kernel "Original"
	status "Copying original object files"
	copy_orig_objects
fi

if (( SHORT_CIRCUIT <= 2 )); then
	status "Building patched kernel"
	apply_patches
	build_kernel "Patched"
	...
fi



-- 
Josh

