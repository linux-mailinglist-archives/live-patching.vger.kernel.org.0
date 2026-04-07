Return-Path: <live-patching+bounces-2315-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sF1hDmQM1WlQzwcAu9opvQ
	(envelope-from <live-patching+bounces-2315-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 15:53:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A86C3AF85E
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 15:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F177301F241
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 13:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9583AA4E3;
	Tue,  7 Apr 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CaTXx7l8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC83B6C1E
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569929; cv=none; b=XcEH75K/ODgNvJkvZN8WVlL46LP8AT7rrjk6OHUtjve8PWWELks4WKT+Q0puV13AhAfCuEiZbMufPiSTfANTccUHdxNgW+W0j19yvjdhkbyAQycbFUchjsoDTUHHnvvVbqSpi0Dt/0UL+bRVmPOjGGYje3PoHhATQY7wgJeyIvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569929; c=relaxed/simple;
	bh=sZK7slSStiXifygBueGYf8FwIze5xkgJ1HepAoo0Yt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnV7QVzpVUHOyY9hDlLJhUZ7v6KVFBsEs+BNiPiS/eNrqlK5VH6O1M8OoG8aGP2Rf9IGyTNIeqZoEY7ISIuUSHcBJ42aOaqlm/R6X1XTzhxHihQz9kGFdj2sjD9cAsFZegzMP3L1RkfqShE6QLZq+8X1wbGeDwoJqhCQZaQEWww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CaTXx7l8; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43cf5d14d6eso4176881f8f.0
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 06:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775569926; x=1776174726; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9Rj0iJqaS4GtsGFAM2U1MRAy3OlGygjlwynVu1x1N0M=;
        b=CaTXx7l8HvWAG6a+GaR1PCJsnZRuG1nKQ1Na5vl8yACtI2DLG+vYXeRG5OZUTYGI8D
         As21YQRdoYqk3RaXvHYcbcvJa3MqrlTVx3XlZpLzl4FzKpuNOpDq8RdFkpz/lYZKqnNk
         SdzNwjiRS51zUJFHsmvFRzGayGVsId9dis1pEHCq4hOU0wPPstP8BvXW4BfjbhDwPbw8
         McjyCpuY5obJ+EctwPK3NyCV9iXk96lxFRYH3/KXu7GqUQrWF790QRTCEDRdBmn/lhfV
         NrsQY1QGEs60/3rbweSty0SdMInRSXaTJaadJA98vjnOo52rkgTzaoyz7AaMBNLOus7g
         hwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775569926; x=1776174726;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Rj0iJqaS4GtsGFAM2U1MRAy3OlGygjlwynVu1x1N0M=;
        b=LFNn8iNi0FwUgqIVOSK+IzlbGYPGCdeMx2iMT/O4PQhlaBMEQ1PTaf8qUdfFCW4iXk
         xtBYvRePHpMwMAEemaX1JNtLoAfjHdQohrB/OMgWJqJ6kt/wlmeqO3MLz1pxvnYqQZ+X
         KM4/yOvJ4y3HRDfDWpFXz42xldcLuIjdeTRXidNicDXeqt0UsnrV9lv/Z4uVRQ/lZNkt
         ntrfGUp0sBVngNv+4QxZ+8T1TDx+gjLm69LGbEtyhMyuByFxV8GzW68/Lhxqv1yHpkg1
         1I6xa07t9piAUNNHarav2RJqMg7xmLbBklg4jjYjWNPEWVx/KDdrTJ8+EG3N99jL3fTv
         ujtA==
X-Forwarded-Encrypted: i=1; AJvYcCUD0NCEGCrovx1YI95sPqPA/kux2cg6pdIHgraCILIIK5QjbS/TgXJEPDlXcUqHhwclwIMDPWFAWHcPADWp@vger.kernel.org
X-Gm-Message-State: AOJu0YwE+9EpTRtPRqursxPIUDPIbafinurpcHaYLbZ+jnl7/sH7PNld
	PXiclP6UrIzJ16wTSr5E8AelMCdZSMTmEfo7W8L+FHqsmLpdLwsNf2tmlbHyHRi5Oe4KQEjP29N
	tRzua9ns=
X-Gm-Gg: AeBDiesn+2WX2SKOh4z3iVRZRjjk8zm3AfXinNy5ZWq1y7tw9qHBREA5RCivUiLLmDz
	ksxK2gzJJ3KVvSbtVPOImB6EXGgMT57027BLtT89P0regtbmPncGc9NHjV+hmJl9Mt3dcKaIdFD
	hKeYmywe9XLVDEkFbdfQd8ona7gMX6K93hzfPli7+Da+oaovMlbgor4vXeSVLklY+XOIzrNDsMa
	DVVoH0b424gm3eV1xwem7dx0mzVoJEr7krUaa4iooJMgucB9udUaRAAvoZKVz9BtJGxvp+zoihj
	z2ep+aKMSN6gQJQxtzxOOYf7ScvT0B9XURoFkQNyAkqVGDsy4Ib2mhWURPMF/nD13vqU9x2iNHR
	SD6w2mtvnaOzSLMEmnKKv4DmI6L6OKGEY1vi7+OdL3yqTzMmzbmw7jnKFdPMCslsiP1+GeYZRbG
	n3juQ64Ck4nAhCi3jSJUUQB0r/3G/+DWjTqarCIxJY
X-Received: by 2002:a05:6000:4282:b0:43b:4352:1bdd with SMTP id ffacd0b85a97d-43d292df38bmr25373308f8f.39.1775569925715;
        Tue, 07 Apr 2026 06:52:05 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2c637asm48288462f8f.14.2026.04.07.06.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 06:52:05 -0700 (PDT)
Date: Tue, 7 Apr 2026 15:52:02 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, Dylan Hatch <dylanbhatch@google.com>,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org,
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to
 klp_patch
Message-ID: <adUMAsZRAC3dDKsK@pathway.suse.cz>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
 <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2315-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,google.com,suse.cz,redhat.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: 3A86C3AF85E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon 2026-04-06 19:08:05, Yafang Shao wrote:
> On Sat, Apr 4, 2026 at 5:36 AM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Apr 3, 2026 at 1:55 PM Dylan Hatch <dylanbhatch@google.com> wrote:
> > [...]
> > > > IIRC, the use case for this change is when multiple users load various
> > > > livepatch modules on the same system. I still don't believe this is the
> > > > right way to manage livepatches. That said, I won't really NACK this
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
> > > circulate the idea internally, but to me this seems like a very useful
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
> 
> >
> > I think there are a few issues with this:
> > 1. The "off-band" livepatches cannot be replaced atomically. To upgrade
> >    "off-band' livepatches, we will have to unload the old version and load
> >    the new version later.
> 
> Right. That is how the non-atomic-replace patch works.
> 
> > 2. Any conflict with the off-band livepatches and regular livepatches will
> >    be difficult to manage.
> 
> We need to manage this conflict with a complex user script. That said,
> everything can be controlled from userspace.
>
> > IOW, we kind removed the benefit of cumulative
> >    livepatches. For example, what shall we do if we really need two fixes
> >    to the same kernel functions: one from the original branch, the other
> >    from the off-band branch?
> 
> We run tens of livepatches on our production servers and have never
> run into this issue. It's an extremely rare case — and if it does
> happen, a user script should be able to handle it just fine.

Could you please share the script? Or at least summarize the situations
when this script detect a conflict and refuse loading a livepatch?

I believe that most/all of these checks can be implemented in the kernel.
And if we agreed to add a hybrid mode than it should be added
together with the checks.

We have already invested a lot of effort into make the kernel
livepatching as safe as possible. From my POV, the most important
parts are:

  + consistency model: Tasks are transitioned separately when they
       do not use any livepatched function.

  + atomic replace: Transition all livepatched functions at once.

If we agree to add the hybrid model then we should add it with
some safety belts as well. And it would be nice to get inspiration
about the safety checks from your script.

Best Regards,
Petr

