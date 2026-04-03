Return-Path: <live-patching+bounces-2291-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGuyGPgy0Gmt4gYAu9opvQ
	(envelope-from <live-patching+bounces-2291-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 23:36:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D25053987B5
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 23:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88DD33025145
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 21:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D56F37D105;
	Fri,  3 Apr 2026 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFBC/7ie"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A496370D4B
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775252168; cv=none; b=Fkm76hOn+Og2bQgJt9BrEBQNZ8BehJQ0uQWqWR/boM0oJhxp4MiZbtqCCVbKClL1+MeC9rJdKeyOdihYJiyZOVRE07ZUaqkQ5/NddI/oV9kDNUit8gtrusJ9cIuve5CH8XzF7rPxOmiquGW9yLFLh67tz0HcMb588+E8fjJVkhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775252168; c=relaxed/simple;
	bh=zGyxR+hJJKYMVjsOFjmcaOeN6w6io3TO38Lk4RE3CKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qv+xqqfy/YiWncF2Ew8fZzszA42yax/Oy9BIJUcZ0r/DuTg9wyMCZ3i6VLgu5amfOlaBfEDigvk59uYPMJduTYFgyGK8OE5hHDDXIvJz+Feux3JGDTqxSMwcjQmV51cMkGQm0BMSDeUTJaPz0M0tgncTh4Ghx1yRx0x2VtpDPp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFBC/7ie; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3CEC2BCB4
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 21:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775252168;
	bh=zGyxR+hJJKYMVjsOFjmcaOeN6w6io3TO38Lk4RE3CKE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mFBC/7iek1dCks1Ox5sgXGZyuOBizY+zyrM+GwZqjqVVJGsqJbwhX6TFhE3441CyG
	 k19Xycm7o04yMkvkF/L1wrYLTg2NUoV4Fmq8CK5sN8gjtDZc1wYL72aHxS8npKkuDD
	 AiA2jVrLKq1rcU1pK+TNmsjhSLwEacXy7sPPMxQOO67G7Gdx18Npsi/bdpumVUv/mA
	 6wH3JveWdEgxLg5a1H/INhjsqKZEZx0TzVqXvbVVKc3lnm2plYHzdCDQHqFokpoU55
	 mN4zW42iadpJM/XOlRuf+LGu0nSOBKozFPICpaKrLwg+17N0jj2pEOr7nnAgKvN1Og
	 dkFRiPzxiCyOw==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a151012558so30728326d6.3
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 14:36:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXiOz75ajPtaNjVK5ZyrZlUoPMYeRECAd1Y4nEKWmHAYXCarQ1TEob3IT+6bkNY9dLrzE3APOAxWljzxM3n@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0M3XgIwWh3tENrYSleakuFD7aPaEafUTDZWyVXyagmTXpA6i5
	o5rzjd5msjsL8qIJ1EMOJq+7j0ZtHipQvQqwf/bRzBh3dayb3Y4/WaqS8XwXDaZ9PnXSZI7TVJK
	WBSpbxDA0A3zb0H+y8u7b4sZDzExll7c=
X-Received: by 2002:ad4:5ce8:0:b0:89c:a2b2:8d44 with SMTP id
 6a1803df08f44-8a7043f0335mr73145636d6.39.1775252167299; Fri, 03 Apr 2026
 14:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com> <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
In-Reply-To: <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 3 Apr 2026 14:35:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
X-Gm-Features: AQROBzCWuZIYMjONZTw9uWMOtylVgKHH2ypWe2SnfDeFDKuhv7JNMaWB-kMCMFk
Message-ID: <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jpoimboe@kernel.org, jikos@kernel.org, 
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
	TAGGED_FROM(0.00)[bounces-2291-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,vger.kernel.org];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: D25053987B5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 1:55=E2=80=AFPM Dylan Hatch <dylanbhatch@google.com>=
 wrote:
[...]
> > IIRC, the use case for this change is when multiple users load various
> > livepatch modules on the same system. I still don't believe this is the
> > right way to manage livepatches. That said, I won't really NACK this
> > if other folks think this is a useful option.
>
> In our production fleet, we apply exactly one cumulative livepatch
> module, and we use per-kernel build "livepatch release" branches to
> track the contents of these cumulative livepatches. This model has
> worked relatively well for us, but there are some painpoints.
>
> We are often under pressure to selectively deploy a livepatch fix to
> certain subpopulations of production. If the subpopulation is running
> the same build of everything else, this would require us to introduce
> another branching factor to the "livepatch release" branches --
> something we do not support due to the added toil and complexity.
>
> However, if we had the ability to build "off-band" livepatch modules
> that were marked as non-replaceable, we could support these selective
> patches without the additional branching factor. I will have to
> circulate the idea internally, but to me this seems like a very useful
> option to have in certain cases.

 IIUC, the plan is:

- The regular livepatches are cumulative, have the replace flag; and
  are replaceable.
- The occasional "off-band" livepatches do not have the replace flag,
  and are not replaceable.

With this setup, for systems with off-band livepatches loaded, we can
still release a cumulative livepatch to replace the previous cumulative
livepatch. Is this the expected use case?

I think there are a few issues with this:
1. The "off-band" livepatches cannot be replaced atomically. To upgrade
   "off-band' livepatches, we will have to unload the old version and load
   the new version later.
2. Any conflict with the off-band livepatches and regular livepatches will
   be difficult to manage. IOW, we kind removed the benefit of cumulative
   livepatches. For example, what shall we do if we really need two fixes
   to the same kernel functions: one from the original branch, the other
   from the off-band branch?

Thanks,
Song

