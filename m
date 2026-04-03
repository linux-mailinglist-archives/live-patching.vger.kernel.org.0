Return-Path: <live-patching+bounces-2285-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNKKOE3Bz2lH0QYAu9opvQ
	(envelope-from <live-patching+bounces-2285-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 15:31:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43BB839480B
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 15:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4CFD3012EBC
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 13:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B933BB9F1;
	Fri,  3 Apr 2026 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ST8A+n/h"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D63AF66D
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775223069; cv=pass; b=rs9l4l9Y6akRs/MttPM1asQhUaXEqX6Fx7dHQrFbHgKoZVxeNrlaj9TZeZWv6UwcqXphNyI5n1ybyAYRjFgh3NaWOcNKwjQR4Zz3ic5xm8WM9ccl0YFyb+q4VouIPvrn8hBLK0LLgFv4ZMg+sc/wXz6nPLS/Gr6dWHno33iQS4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775223069; c=relaxed/simple;
	bh=c2L62QsoV95txLA+XVc7yZbDzuoSFBDOFQIxHtl34Bc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ti5tD8VcliC2h86HGasnBP7fZV7+TC6U2U/DjYlT1cYZfmh5OYytpO4SV2N0G9FSFcBPdaxrpN/ccpPJXM6GT1Bk0u4DAXthhehSJQ6KmvE85CScwI+0E/Zsr/72DVnBMdKTb4VDQvdN7X+YFkuYXzM7rPYhW9WrWWbcm3HYT48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ST8A+n/h; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7a43424f861so15524267b3.1
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 06:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775223067; cv=none;
        d=google.com; s=arc-20240605;
        b=RjRYdWHOXynlUy+vsmPuDxlfxBydYE5ewOrFwjUIpUVtDQLThoQJV6dFHzLkmPKQtk
         rYEsTt1kG4qagrUC/S684DW3Iwap9y6v2mMAHufU9UTS4mFSCnSMmoZ4xRRd3dGcTQ20
         kZUr8M9fDxLqFxIwk5ompTsQ5j25GTT1R4cmap+QOEk07dwi0P1Wvu/w1ctyk2RZ6oMW
         h26SnDqnbEZlEw/mseNySDPfjREHwKC7l+MU//mqe6eZGChB6R8dcKE7dOfDDBE3xprA
         H8s3xxOS7YSSMUL14l9hpLKkALz+XHWO0M+9JVCqCgFkCZ+fHNiwqnW3Jlk1Vh27iZb3
         s6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YLrHKhwlQGiXbkZ8zYh4kD8n6Ck1PfmwiVDlhPHBfN0=;
        fh=MXWl21Yj56ay19XUHk1cZT1BmSeb6yxelbCR9VXo0zw=;
        b=UOz+TSjtyZahGAmd4jlA2T0VTkBGjPWRLSM8fZoLZiCUrL7kSo/4NlFOJSdb8+5AJB
         P+hMlNGSGNHZXjijx1dWWQFsQ7BGCjXKsvQuzjQt3K1ME9CIfpcohPawL4krFmuTUB3n
         OGLkOnYfNEWvvlDGhp4V3v9GLvZ6MWFe+HCKSbW8gSU42b9eLY7CqMXQgb7wRBObeK53
         wPHmh+3IdTdJ1ixXajIeSNe7/gx20eR/+oBL5EmKGILUzkH9+RK5YJLm4WFqiJAgbhWz
         f0Dx4ecudoRmqny/nP9VeP5PTb5MNdMIHB7GM/i5mk2lxcEbxeqM+BzGvldwp3y73z6G
         iP7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775223067; x=1775827867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLrHKhwlQGiXbkZ8zYh4kD8n6Ck1PfmwiVDlhPHBfN0=;
        b=ST8A+n/hsRReq3zeoPUE7unK/HASRKTU04fkVjW3LQMlUsb2r90FiDzwkQz2mlCxor
         IBqEfxBZ6Rz3kv6UtnGK3bQFHbZWvIbTSaGCFUai+MZvDZW0eD9Bmt8fwlc21O4i5yQH
         eEwPmKb5VCvZd6LHZ5u0g8RflyBFOhYU25y2L1W9CMi9cE8EAE3H2uZKZcpI/t72t1pc
         ZBf5JGgVLb2BjZrQpZWNsapYXY7XggCiFVi6cYXdJDCr21jgFns9El8S8sLgNNtchZMm
         phSdfEvrvNs4rbH9FP0l7z+S8zZZQzWOymZ4Yyrdis6kZxCV/3diICzlQjnR7h43l6Rw
         3frg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775223067; x=1775827867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YLrHKhwlQGiXbkZ8zYh4kD8n6Ck1PfmwiVDlhPHBfN0=;
        b=RW4Vq5aBE6l6UB3AtamFSVqOstvQAanxvR7s4vwHRXGzMz1e/1/E/CWJl3QJoP1t9F
         KeZgc0e2JYydWv11clpLrI7sjTTRVz6R0eoztQf4hCLkX9IUdPYKhbBNcDu89vP1+eOj
         /Vq1TWzAOm1ghlPuo1W4r51TQh686VpoQ1WSQahzlAVpJPWl/6Q13tPRjTnnGhAyDNLr
         L8ulT0OcnV3rb5g3WSMPy0zDx7OYHeEz3OS6EbcvpYPxNCsZtd1s0ENNIqsC+GLE2yeZ
         KDPcLlkQ19Ns2UdXQOOv5W7jp0CExbdzezXxiv9ia8Ik4lvJax/65YtbBxSBZfyngXOc
         WUAw==
X-Forwarded-Encrypted: i=1; AJvYcCWwny9i7WQuZfUTACVoms0jEsgkkry7/K9lBdoOvX3iCo6rRUTi8rL0kE/vgsCBKtHNZb/cJEV3eYJ4p2DL@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw16lU6/rGsBTn04M0PgvQxG0Vc74YwnqfjkLX2LNVvx3cDz+a
	zhAiyeHicBUaec3eh7GxcWaNimhdEq7k5hGLQTQj+jVUxdX1QZEqxtHUhM6+vcArdNyI+Prut79
	5BEO/6781Pacx59GUsjsmYv9HVkCo/ko=
X-Gm-Gg: AeBDievwOfF4JQwWnhkxssiKSciX3HpCd5sAm/kzEbo1+heptUMqHaI7nHG062Wdego
	FlNMJZrDMDz2yhdSeZ0MuQtlYGrg0+51uTEQ2rnydZj3XE9AJpNRHEPtWBr89yj5D5Vl+l4c5OI
	KlK7Hf0mnzKtmnstIJwIlFzaMPjns/LT85mWDH0ju+oy9mWWvUFX9mMN90XGn2DwJ89ELS0iUXv
	tNDo9qOFvU1W3EcOJqqYMdsGnMRU9ww2pBOL5MsqO2T9o80We99uqi1MzC7zYvbAx36qLieuh5e
	xhrpEiwN
X-Received: by 2002:a05:690e:4197:b0:650:146c:8784 with SMTP id
 956f58d0204a3-65048887999mr2345797d50.54.1775223067525; Fri, 03 Apr 2026
 06:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <2261072.irdbgypaU6@7950hx>
 <CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com>
 <3036842.e9J7NaK4W3@7940hx> <20260403073055.031275d9@gandalf.local.home>
In-Reply-To: <20260403073055.031275d9@gandalf.local.home>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 3 Apr 2026 21:30:31 +0800
X-Gm-Features: AQROBzC0mSPveSQN9--WA0G0y_aVn1mFQhL-xBcxwejlBO_z72oaRKJrd1eJo-I
Message-ID: <CALOAHbBBf_vWcwZp9kdXhpFOq_oG87X-7Nj2yurZ6LgBpDHwwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Menglong Dong <menglong.dong@linux.dev>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
	mattbobrowski@google.com, song@kernel.org, jolsa@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2285-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,kernel.org,suse.cz,suse.com,redhat.com,efficios.com,google.com,iogearbox.net,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 43BB839480B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 7:29=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> On Fri, 03 Apr 2026 18:25:59 +0800
> Menglong Dong <menglong.dong@linux.dev> wrote:
>
> > I think the security problem is a big issue. Image that we have a KLP
> > in our environment. Any users can crash the kernel by hook a BPF
> > program on it with the calling of bpf_override_write().
>
> Right, livepatching may allow for rapid experimentation but that is not i=
ts
> purpose. It is for fixing production systems without having to reboot.
> Using BPF to change the return of a function is a huge security issue.
>
> >
> > What's more, this is a little weird for me. If we allow to use bpf_over=
ride_return()
> > for the kernel functions in a KLP, why not we allow it in a common kern=
el
> > module, as KLP is a kind of kernel module. Then, why not we allow to
> > use it for all the kernel functions?
>
> Right.
>
> >
> > Can we mark the "bond_get_slave_hook" with ALLOW_ERROR_INJECTION() in
> > your example? Then we can override its return directly. This is a more
> > reasonable for me. With ALLOW_ERROR_INJECTION(), we are telling people =
that
> > anyone can modify the return of this function safely.
>
> If this were to go in, I say it would require both a kernel config, with
> a big warning about this being a security hole, and a kernel command line
> option to enable it, so that people don't accidentally have it enabled in
> their config.
>
> The command line should be something like:
>
>   allow_bpf_to_rootkit_functions

The feature is currently gated by CONFIG_KPROBE_OVERRIDE_KLP_FUNC. In
the next revision, I will rename this to
CONFIG_ALLOW_BPF_TO_ROOTKIT_FUNCS and introduce a corresponding kernel
command-line parameter, allow_bpf_to_rootkit_functions, to control
it.

--
Regards

Yafang

