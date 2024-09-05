Return-Path: <live-patching+bounces-604-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7E296CDA0
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 06:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E43D1C221D9
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 04:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865FE13DDAA;
	Thu,  5 Sep 2024 04:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lhyu2Jpy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FACD48CCC;
	Thu,  5 Sep 2024 04:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725509757; cv=none; b=EtHEpfx+Z9GklMg1LQ21xKfbctz6faTq+7SQAR1m1YV00L3Bdqf0QjMeyUsx9A2SddN5QsjaZxuOq86RgZ7b9SlNeNTdIOFj3EkPexvt0lfBUOb/Mc2p1nstf4MFPotrrgDb9c7mH8HVcoi9p/u+leTedyo4VLgBjUYGZ3Whng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725509757; c=relaxed/simple;
	bh=M8O3DlEL6KSiYNC/41n757CTw1sOYdlTtRJSAmeCOr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WULyJmUHaglVygKsrzGiCrA2MpM44qcZuSK36F7IqjDkRq8//kdGd1rIsBkD4j2CE2M2DXoegGu+U9qwUKpgU3dqLNa7PWF5AzvnOHpit36bEWyArNwHc4Y+4P89yBqs6uITojunoLYLODX1Cgm8cy2yet/6HhLuRky8hMMzXp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lhyu2Jpy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E5EC4CEC4;
	Thu,  5 Sep 2024 04:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725509756;
	bh=M8O3DlEL6KSiYNC/41n757CTw1sOYdlTtRJSAmeCOr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lhyu2JpykeFVgbhx+aFZ+bnE/ktyEb12NJWDHgL/TqtbLoQJRl3N0uNFNyqBjm7BQ
	 oBPlH878XnH8te+CPixOxz3adbVdpZwqBxVNQYhM5iM2yoz2PTuOgyhJ8CBz6Lc1rx
	 ovnF3DDr46noa4miZ8xI+M20KFDRI2+J9lFpzHLSHT3crlFJMqdqhFtHncsu9Y/F6T
	 IzGdWed/NTSA/UxAncxuxGc/+eU47Vzkn2uNK2fL2sz17cUsBwD05Qyq6BMK4QZ4yK
	 upAK1cpM3Yk/fSg6YzGvEysJxqidfKjytmtTGHL+Ymz9EY0+YNEDjnsIrE6Nu+OeCf
	 PT4D3Noyur1tg==
Date: Wed, 4 Sep 2024 21:15:54 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 31/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240905041554.2kgnwuiketn2rrdw@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
 <f23503e2-7c2d-40a3-be09-f6577b334fad@quicinc.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f23503e2-7c2d-40a3-be09-f6577b334fad@quicinc.com>

On Wed, Sep 04, 2024 at 02:38:14PM -0700, Jeff Johnson wrote:
> On 9/2/24 21:00, Josh Poimboeuf wrote:
> ...
> > diff --git a/scripts/livepatch/module.c b/scripts/livepatch/module.c
> > new file mode 100644
> > index 000000000000..101cabf6b2f1
> > --- /dev/null
> > +++ b/scripts/livepatch/module.c
> > @@ -0,0 +1,120 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Base module code for a livepatch kernel module
> > + *
> > + * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
> > + */
> ...
> > +module_init(livepatch_mod_init);
> > +module_exit(livepatch_mod_exit);
> > +MODULE_LICENSE("GPL");
> > +MODULE_INFO(livepatch, "Y");
> 
> Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
> description is missing"), a module without a MODULE_DESCRIPTION() will
> result in a warning when built with make W=1. Recently, multiple
> developers have been eradicating these warnings treewide, and very few
> are left. Not sure if this would introduce a new one, so just want to
> flag it so that you can check and fix if necessary.

I'll fix that, thanks!

-- 
Josh

