Return-Path: <live-patching+bounces-2296-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNPIEaH302k4ogcAu9opvQ
	(envelope-from <live-patching+bounces-2296-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:12:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D46C83A60E8
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E4D6B3022557
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E778D3921D6;
	Mon,  6 Apr 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpHAp4cb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C838F94A
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499100; cv=none; b=b48nUMlxgu6PXK58+xxoQZr5s71gbyw6T6dyWEy+LGG0VI/9KVqNk4IkSkjmLlh1qk4fVtAJN5bCt3ib67QtQzrlLqOcwePu5ihUC/X6Oll+Uo63PXn6v0EXJz7MNo8GS9WOEzVZJsTor6VmwHlLjYUBjuCkyA8l+fBSFGGtH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499100; c=relaxed/simple;
	bh=FCmiQ7qR/HkeyDQC1w5V/E7vD9N4Qx2dGVi6447g0h8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dl+JGIFv11N51+KeySX/Q110js41dOZi7OlmLVbS7h6io4K20m1URToQYa+qxI9xB+XNS6RX4IkIpcs4FfpvIgMr2k7Y9exMLfGCz7AtA93DeLiGjxIr4fFRjq1P7u/DAZ6nN62oC+uB0byC5DdAK3McO5Q9AUhG6vaChpeWG+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpHAp4cb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DDC2BCB7
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775499100;
	bh=FCmiQ7qR/HkeyDQC1w5V/E7vD9N4Qx2dGVi6447g0h8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bpHAp4cbwIEmS7F5pVu/nkAAmPhZce79LP8/ERCarEd6gM0oLbACKuGFTDgAuSCxT
	 sXnMphvgGwshBACkOQzvtgjd4nIqQXwzlhakz+EUND+K7/EJk/EK6pdZUb6ELdkDoB
	 KOOdl3tPRC/x/FsBn8OOEdq5A8+Ke2kN69+meklvxOxECwgynlLGf9YZ2Kg49QUTWi
	 lEOa/m2mvrUiUlnwee3YyeVhzYcWi/Yvqln4IUkHCvoC36do67wCSwC3RDOd/pMDE7
	 XN1dhvaMCG5Vs2uWiQ5SysGtnM0mRg8C45fy2eJSQsBbAg2k8WiGAyQNd8K3I+Ep5Y
	 LgO0OX4XANIWw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb40149037so482771285a.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:11:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUacgQjcqk+9cKWk9hAIHbErScZIli1WypUu28dkZ/3VXwxIDCf3HjFky4v9dmDz5XfoKi3v/sL3MjiJGut@vger.kernel.org
X-Gm-Message-State: AOJu0Yw39nOf3NakzV/Rq37HPk1HOVBWbZzETf7s8c3rwJXYkrywXcWu
	L0GM7rsPBWQTkkqEz+Gh9zyowhf4iY0zqOGqGJcuOpwPwkZlB3uNXYmSgNe5Qbg+9xUeLLYDSar
	DIcQlNhRIZGvXxNPrAcpjTA3GlGEknrs=
X-Received: by 2002:a05:620a:29c1:b0:8cd:b620:9be2 with SMTP id
 af79cd13be357-8d41da571fcmr1912531885a.38.1775499099536; Mon, 06 Apr 2026
 11:11:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com> <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
In-Reply-To: <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 6 Apr 2026 11:11:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
X-Gm-Features: AQROBzCFxkHfl2egwPNA3sbElolh-AgrieM9ssltLgTibswoiE7pp6N7fR9JnT8
Message-ID: <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	kpsingh@kernel.org, mattbobrowski@google.com, jolsa@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2296-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[google.com,kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D46C83A60E8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 4:08=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Sat, Apr 4, 2026 at 5:36=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Apr 3, 2026 at 1:55=E2=80=AFPM Dylan Hatch <dylanbhatch@google.=
com> wrote:
> > [...]
> > > > IIRC, the use case for this change is when multiple users load vari=
ous
> > > > livepatch modules on the same system. I still don't believe this is=
 the
> > > > right way to manage livepatches. That said, I won't really NACK thi=
s
> > > > if other folks think this is a useful option.
> > >
> > > In our production fleet, we apply exactly one cumulative livepatch
> > > module, and we use per-kernel build "livepatch release" branches to
> > > track the contents of these cumulative livepatches. This model has
> > > worked relatively well for us, but there are some painpoints.
> > >
> > > We are often under pressure to selectively deploy a livepatch fix to
> > > certain subpopulations of production. If the subpopulation is running
> > > the same build of everything else, this would require us to introduce
> > > another branching factor to the "livepatch release" branches --
> > > something we do not support due to the added toil and complexity.
> > >
> > > However, if we had the ability to build "off-band" livepatch modules
> > > that were marked as non-replaceable, we could support these selective
> > > patches without the additional branching factor. I will have to
> > > circulate the idea internally, but to me this seems like a very usefu=
l
> > > option to have in certain cases.
> >
> >  IIUC, the plan is:
> >
> > - The regular livepatches are cumulative, have the replace flag; and
> >   are replaceable.
> > - The occasional "off-band" livepatches do not have the replace flag,
> >   and are not replaceable.
> >
> > With this setup, for systems with off-band livepatches loaded, we can
> > still release a cumulative livepatch to replace the previous cumulative
> > livepatch. Is this the expected use case?
>
> That matches our expected use case.

If we really want to serve use cases like this, I think we can introduce
some replace tag concept: Each livepatch will have a tag, u32 number.
Newly loaded livepatch will only replace existing livepatch with the
same tag. We can even reuse the existing "bool replace" in klp_patch,
and make it u32: replace=3D0 means no replace; replace > 0 are the
replace tag.

For current users of cumulative patches, all the livepatch will have the
same tag, say 1. For your use case, you can assign each user a
unique tag. Then all these users can do atomic upgrades of their
own livepatches.

We may also need to check whether two livepatches of different tags
touch the same kernel function. When that happens, the later
livepatch should fail to load.

Does this make sense?

Thanks,
Song

