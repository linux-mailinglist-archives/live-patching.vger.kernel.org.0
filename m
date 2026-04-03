Return-Path: <live-patching+bounces-2290-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id vE7eFFgp0GnS4AYAu9opvQ
	(envelope-from <live-patching+bounces-2290-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 22:55:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F343984AF
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 22:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C3F8301DAF8
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 20:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C903D7D71;
	Fri,  3 Apr 2026 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mUvAmWKp"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D520C3B7B79
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775249740; cv=pass; b=pCgzvM1ruPA0QxB2FmM4qkK1zWt2TIVLh+W9AgN6SbXKaAYbP6rMvTCJjd76mMO1ZhQw4OIIMeg6SfNuDs12xfacJzNloIjMYyuVGZchnxbzWeh25bV0dnAochk139UJVP950LPZOx4R/EvuJwuSdaJwKyfGNuFdofsYUzlmY1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775249740; c=relaxed/simple;
	bh=sTUwcd1bS2S1zzg6SweuuUmPEJiJW90biTuK7ZrcV0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQ/RiXvj+xryknqsW1IZ9zwiFox5AJkwjKLRFNWxnkk7m3zhlJrBOMlKUJdGAq650rmR6G6yCODN0VB6tZu9T3PvgTsKtTFCT5RDJWzIl5QIB6WoXGGZYQnNc3YF5jOqI8JNf4X17xGLa94XY28d+quUm0oKkidnJ73ofroaoVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mUvAmWKp; arc=pass smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-56daad0fdbaso373860e0c.3
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 13:55:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775249738; cv=none;
        d=google.com; s=arc-20240605;
        b=e0teM0d7825ni1gWofCN1pZb45fYUXLbwvIe3FQfOkqpPP0PqJ+WX/j0gEuu9qnCcE
         8VeNwdF9JXIcsPUjR4CTTo/vZw2lmtje5P90t/QKya0sBl5v9vlaS2AsKP8rjqxI9FSM
         VjsBXNvcjiGNB3P23rFYENqtLSSsVyPrn6Egjngk9enGzoPSEZMtWFzx8zgkECUV+WD3
         fprbWvY3njYZNwmj5tOpI+ZWPEmUEA9XcWm9C7G7obQTXhaTEOrGz0zwvzh5CibJYHas
         ydzanAGkBIG4VXZ6icttC0mThnaVIQH9yreFW32VmCKTn8vjAAGj2EObYk3OBxmcOqDi
         BSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sTUwcd1bS2S1zzg6SweuuUmPEJiJW90biTuK7ZrcV0Y=;
        fh=sbvE2CInThm+Dl1zwcSAehFOoGd3rFUZBlTJQujbfyw=;
        b=W9ZVozXD45782qNEhSF0nw5pEy+OLd1Br3Odn49298xfiSCmbrrVGYaQkJ8ZT/wUoJ
         J0JyWcRuI1XUgkFhb82YP+ZfYW6qEBOh01PT8FYfngXHy2In+G3FEVANMwImRitrb9Si
         IWHff4CXcaM4HHk1+8OgxdMPvUd0c7o8d8B/sSczSIsq6fghX9wIbQpnUnVOqKpEgkhv
         rZ+nnnVrwutupygxMHA7O2rP9m/pd2GoYfNiVTcIcxfjky7YUd5GScBiMTtEGG5cUapW
         RTjQkf2ubHp6t5GW03tOhX5BtzKwRMS4aRFRDgExjx87cIm3OhTpP/NabZ2YlQMDiRDM
         nUvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775249738; x=1775854538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTUwcd1bS2S1zzg6SweuuUmPEJiJW90biTuK7ZrcV0Y=;
        b=mUvAmWKpvN/9LbApy+wztqY3qewQZwuDLW3ValldzBtNBP0+fu5uHtoGWZ0sGlTCwx
         zOUMdcFVPwFvdyK8KbddaZIAHpbesm3s0VY857T9dH/eyQ+eEngRz69TwzB4n87ykIn6
         LW02Lx4OSBBalkO9vXDfbfjppm1Si+yX7rfCULkaSsR50CAAcH/v0JZ3LGxROuxKkMvj
         7dEEu+5JV57dqwxxbU61QqhHEW9jggHwG35XnJT0fzGIptpPPUdXIA0bCAIn2JXiYjp/
         gqj3mgy668Npm0GmsrxL6t5fnF+FFAs8Fhr1IZBD4rp7LyfaoYgFG6oeuQstnpltgag5
         5Wxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775249738; x=1775854538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sTUwcd1bS2S1zzg6SweuuUmPEJiJW90biTuK7ZrcV0Y=;
        b=e8tYzWxbZJFMc6RzLF5sIIh5giINUwG3RTtCqBbS4P7YOP29eGAx1X+Fnm2unUgXE+
         f8+L4InSPSXRit79+JZ3LptFFMf3ZasVxwrHsPJYF1olUqElT18/QYc5p4DQgWwj/B3c
         sjDFwzFQF64VIXTc8L3/BKX11S8LxDAlwkJIC8pawyxDyYy8A/j1YSgrNWpZ6wZzLGBm
         i8ey1++sc/P12ywXvhMa2zjWA5LT78Cgo3XXmqDF/y/vEK8Pv93nQo74GaEVT8yp0e85
         wHzvbFkQkBOEGbpUWKQK1sLQlEPyew7rDQakg2JDiqFLYDgufZ4316pUEDvFsRVSoBqi
         1W3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVU2nZo6Z2f8amdl2gTdjROt7DDT7IomP5QlJ7s1fXLMciBt+it/PD1VMWMPH/tJWCiaQTLw+D4LR9FFvZz@vger.kernel.org
X-Gm-Message-State: AOJu0YzrEZR4JCpcqgD+UsI28mCVh7r1/Jh06wbz/+hs5KnPBGsFExbH
	mEwN3fxDAKy5ghSdqPqOq0Mk9/432vmgTOMRzbzGTEWmv7NH5Rb0U4E2FxULrNEY4C2MGXebmPW
	K5O0zL0GQhZTtNBnFA5Mybqxh/W5a5m/jIG0+6KzN
X-Gm-Gg: AeBDiet8nU+z9JCWIxWhe18GqhcZ60Hy5qmu0Ik5/F/nsNucXkHoKlCOpnxVQ5Z071X
	xe8E4kE3l37NJxbr7Q/UsC0LG3o7oyC0Acf++6g4wrXmTXoYDcBOHa+3zWtEUzaFX/wY0wYqe2Y
	oTQGidT9++g2m066CxPg+6VsRJrPjd7vCWVQ7RbADugpRKFx9zLM4rhmdM8y51gs0BqVueTNiSi
	hSutgSMRwldD3yx0cyS9mRx1BPeFtvD204XAXfno8y/vuf2yKPUffpDC6cYqcRz7TyTVganbR/c
	DdJye+uFQ9N+kfkjGJA=
X-Received: by 2002:a05:6102:b14:b0:605:26eb:cc1a with SMTP id
 ada2fe7eead31-605a512c49dmr1509501137.29.1775249737225; Fri, 03 Apr 2026
 13:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
In-Reply-To: <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Fri, 3 Apr 2026 13:55:25 -0700
X-Gm-Features: AQROBzDS37OjmfrI7p7dlg7HXRfbNYrPo6MbDjUEgtIBQmy-W82lfbmdNqsszdI
Message-ID: <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Song Liu <song@kernel.org>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2290-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 51F343984AF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 9:19=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > Add a new replaceable attribute to allow the coexistence of both
> > atomic-replace and non-atomic-replace livepatches. If replaceable is se=
t to
> > 0, the livepatch will not be replaced by a subsequent atomic-replace
> > operation.
> >
> > This is a preparatory patch for following changes.
>
> IIRC, the use case for this change is when multiple users load various
> livepatch modules on the same system. I still don't believe this is the
> right way to manage livepatches. That said, I won't really NACK this
> if other folks think this is a useful option.

In our production fleet, we apply exactly one cumulative livepatch
module, and we use per-kernel build "livepatch release" branches to
track the contents of these cumulative livepatches. This model has
worked relatively well for us, but there are some painpoints.

We are often under pressure to selectively deploy a livepatch fix to
certain subpopulations of production. If the subpopulation is running
the same build of everything else, this would require us to introduce
another branching factor to the "livepatch release" branches --
something we do not support due to the added toil and complexity.

However, if we had the ability to build "off-band" livepatch modules
that were marked as non-replaceable, we could support these selective
patches without the additional branching factor. I will have to
circulate the idea internally, but to me this seems like a very useful
option to have in certain cases.

>
> In case we really want a feature like this, shall we add a replaceable
> flag to each function (klp_func)? This will give us fine granularity
> control. For example, user A has a non-replaceable livepatch on
> func_a; later user B wants to patch another version of func_a. Then
> some logic can detect such a conflict and reject the load of user B's
> livepatch. Does this make sense?

I agree with this. The ability to reject livepatches that try to
change functions that have already been patched seems like an
important safeguard.

Thanks,
Dylan

