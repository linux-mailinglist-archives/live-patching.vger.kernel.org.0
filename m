Return-Path: <live-patching+bounces-2324-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iL/WHZqc1mmyGggAu9opvQ
	(envelope-from <live-patching+bounces-2324-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 20:21:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4071C3C0790
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 20:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2462E302B96E
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2026 18:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E1C3D905B;
	Wed,  8 Apr 2026 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZDp/B/s"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F58B3D904D
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672403; cv=none; b=Y8xFGgV/Sos96C/KipdK2kchSP7qKxWl6Bsn+Oj5qcD+9YTInejfyBz027WliTUBivtGqHtNi6JmqFYcG9MfyzSCSVV/Z7tQ2ZZ6ZyZ8qOTUhv1m89ob1GO5FHa6BFVOzKRSA1YbVoV8VAavX9w7xO0ME/p/ZF2K9ZtO5mxJqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672403; c=relaxed/simple;
	bh=QWyyjb8yrf7T4LkpQ/fS0bsphkrKWYfnmeHKmwhlNjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aQqLCe38IZREmUpCxVHKW3wrtOvqaczWW9zDni6I7IskUMR7ntJc4b2QaQIiieg3U7h/7+ptS5PSVzjgPomSBiBJHOOGzoEBhTPm5Th5ARrK89stAiuevVORo2Ay9X5KUohdArqStGxStb9A+wPv5X08CEqYV8sYHEC0LBComlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZDp/B/s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F51EC2BCB0
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775672403;
	bh=QWyyjb8yrf7T4LkpQ/fS0bsphkrKWYfnmeHKmwhlNjM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PZDp/B/sp0vMV5vF2b1qu39xrSKO0SkoFzfiZGVngTU5HPADqjrucR6GiY/HhGsMT
	 Ak7NEIvzB8HZ3Vo66tfHKKV84vVnQo9ZV93e5kuoAk5oiZr8pmTvnsjGR9pb0t3C2S
	 JzzefvHFPoH77XqjXVMO2XWz+kMfXwkKOlc8fL9ZjqkcTOaH/1uE0cIILPgJaoZe+n
	 2a60pvwx/DqN0PB3aOrNBsb+rBdH/zirkWhod5SdNXZzwKhVHMnSGgXQUAeyC0au4Q
	 ysbljTp5wzjI6PKwUTpZrdfHcFApzeVDIhyschnFVQUxOWA3xzktWHjMAEe0b5Qx1b
	 EpZ0Q+ujwBjtQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a068db9989so629056d6.0
        for <live-patching@vger.kernel.org>; Wed, 08 Apr 2026 11:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU9TFwo/IGuq7bs6IaqOT/JXhajcue3hNY0QNIE9KXv8MpvpxQ6yZtIvxaJlDKPQoxuB0uwLGILIg/fhtjG@vger.kernel.org
X-Gm-Message-State: AOJu0YzKnEyNvoavzVF97BqTH4TN1cMkSzHX3hPqDmPyhrkCrgUbNmys
	ml+XjfhgjezbLiLooPNY9whD6aCXGox3e/uL3VGFdEwz4sz1ZVFep2bZCp5HJAfAOGYOueteJFi
	bHScAa+TM1BEwWxeko31AaEiR3nfzMSo=
X-Received: by 2002:a05:6214:4699:b0:8a7:164c:d5c8 with SMTP id
 6a1803df08f44-8ac746bec7fmr8189476d6.24.1775672402156; Wed, 08 Apr 2026
 11:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
 <adUd0Mojbtrwmeod@pathway.suse.cz> <CALOAHbDG9mq1iJv5suct=cqJ+2r8VvJ-dXN=nuvMw0XYqnUjxA@mail.gmail.com>
 <adY_WgA54CDtWBq6@pathway.suse.cz>
In-Reply-To: <adY_WgA54CDtWBq6@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Wed, 8 Apr 2026 11:19:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW42WqGuZ1Z-RG0yzifZ7rh=XKUa5hKb6JxLeTWdc4s4-A@mail.gmail.com>
X-Gm-Features: AQROBzDWe_vpf5f0DrH1BpfkbDrq31L-0Z60zRTstiTlWDjm9dqpqQwJLlcic4k
Message-ID: <CAPhsuW42WqGuZ1Z-RG0yzifZ7rh=XKUa5hKb6JxLeTWdc4s4-A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2324-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,google.com,kernel.org,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 4071C3C0790
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 8, 2026 at 4:43=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrote=
:
[...]
> > >
> > > This is weird semantic. Which livepatch tag would be allowed to
> > > supersede it, please?
> > >
> > > Do we still need this category?
> >
> > It can be superseded by any livepatch that has a non-zero tag set.
>
> And this exactly the weird thing.
>
> A patch with the .replace flag set is supposed to obsolete all already
> installed livepatches. It means that it should provide all existing
> fixes and features.
>
> Now, we want to introduce a replace flag/set which would allow to
> replace/obsolete only the livepatch with the same tag/set number.
> And we want to prevent conflicts by making sure that livepatches with
> different tag/set number will never livepatch the same function.
>
> Obviously, livepatches with different tag/set number could not
> obsolete the same no-replace livepatch. They would need to livepatch
> the same functions touched by the no-replace livepatch and would
> conflict.
>
> So, I suggest to remove the no-replace mode completely. It should
> not be needed. A livepatch which should be installed in parallel
> will simply use another unique tag/set number.

I think I see your point now. Existing code works as:
- replace=3Dfalse doesn't replace anything
- replace=3Dtrue replaces everything

If we assume false=3D0 and true=3D1, it is technically possible to define:
- replace_set=3D0 doesn't replace anything
- replace_set=3D1 replaces everything
- replace_set=3D2+ only replace the same replace_set

This is probably a little too complicated.

> > This ensures backward compatibility: while a non-atomic-replace
> > livepatch can be superseded by an atomic-replace one, the reverse is
> > not permitted=E2=80=94an atomic-replace livepatch cannot be superseded =
by a
> > non-atomic one.
>
> IMHO, the backward compatibility would just create complexity and mess
> in this case.

Given that livepatch is for expert users, I think we can make this work
without backward compatibility. But breaking compatibility is always not
preferred.

Thanks,
Song

