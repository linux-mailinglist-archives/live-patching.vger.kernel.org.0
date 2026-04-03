Return-Path: <live-patching+bounces-2284-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AETtI5TAz2kM0QYAu9opvQ
	(envelope-from <live-patching+bounces-2284-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 15:28:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB81F394751
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 15:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A992830305E3
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 13:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0713B895B;
	Fri,  3 Apr 2026 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SagRcZ8J"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE03B8922
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775222851; cv=pass; b=oYm0U8Avkkom2IMS5xZ6k56TLId2q1WgJnOEOMqdV6hVlEdazVZ15DqSSbmjhf7YuLSYpPvXNhlkYKf5PGZOQi0bpjsGs6oo1NL1JA0ongtI7biRKHM6dRaI+lQpu162I6mnn07D8glqz1KSOJ/xBZHpjBIwuzTyJup87uUFx6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775222851; c=relaxed/simple;
	bh=u5aZYLglLR2y0VL5RObQhknUHMYSLmH9b+G9V9Pt0TI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SIxPfb7Y1vy7bDKBYRJxW7u7R24sfWLDc35dwFV4HSS7nTYU61y77HJkLiAJ9ZgY9YXGChzkVlUY//P75OqpKTo9WH2856QbjtAVHKBS1HTVMYX9qfF6Ze5Vtr7dCUJTRE+wSJl0AuNIYW3KHnBTxCQBESD1LWYnCg5LX0OW+Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SagRcZ8J; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64d5a7926cfso1790163d50.2
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 06:27:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775222850; cv=none;
        d=google.com; s=arc-20240605;
        b=fSzG0zjk0nTD6Y2DQHzIxnf0DiFvtS2U/SsJHe12M1tFNlZ+f4CZuw0YD2yRoOSYcG
         HQbV9O9EYjHHBMVF1TMkjJn8zfRI5wwUIZeom/KkG+DuxYt8cyjWYS9KAy7se9T75RN5
         d3p1WAMojmNy68FtdMrvR88LLWnDjkLRBG3OD1ovPDl6wohKYFEYCJhhJlr8ZQHJRFrz
         +iUrmIeNVvX4+fDUvNDNKXKcjiqo72H1Shr5znBiiN5k10hvLfDV3jI9VppA0v7Jm3S5
         U6XvrFCE+L8qsUQOJQCgf2U0vQXJASd1m1a8hlX5Ogxvp3lw1RP/na32LUjplZVrj91h
         E1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5CVFkoDCxGsxXBj8bPmZ7vpSl4MJkw0Z6mvu33ifBL4=;
        fh=RkSVGRJCVhv3e9mZe5YSU8OPPT07rtYt207QaYBtvX0=;
        b=NYoemP5Y26JLTZfMgsO8pK2+EtYy1sFYTpvPzzQz3x91YYX/nptDhlBxqZ2sVm6SPV
         foeVNrRxszvbl90K6XnRqZNQ9K1LhwoOYeQsU1nQNUIvE5N20dIi6UUONn9DuoOr8Je7
         YjXoDIUNWunIiNT31j0M5TpE/hi1xwQE9sUI8YuAo8kCmUptFC76ouQMP5Aw7KsvuQVF
         xAFTclV6HdSGOJEmFsgZkBRnwHkzVjXqbcpfrgSNG+XRWgDyTF9nuCymA1tZvufztq8i
         zuhw1ErjX5R0cFfi7PpSF2Tw6eoeHmsy4IlOVDV2kEsk0TUQo7pFilJ59xfwMQom3rVs
         YGRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775222850; x=1775827650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CVFkoDCxGsxXBj8bPmZ7vpSl4MJkw0Z6mvu33ifBL4=;
        b=SagRcZ8JiTwqsvgoHBnI6ZtmliRgom9WwP9ARyt4eQJpUXiNmywuCPIWmiUfVsk4n9
         QK/E81CiRNOtX4vwyJvfgNZ9DhZcQmeBJF0Ki8tU4CLvv4k8jaeMcFuOnphkUReyhOvF
         LY9Pl76lAfJgRFIXMGZ1jkyfEIEldbQEE5LLD6L17RBoupok/cxFFIiR3Euu4boB3BEc
         EBNjBSCO7/oxgo1bM12fWj7/8qAR7hT1Sl63CgN+exA6qbUg3DJAT+7/cc/ettTp9FI7
         pb+ylDk8iNV8+llVODWRNNhDvmmgrSpTiVjYp6k02vl12sKI5cepp8h5PhA+tSf+Iam0
         CuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775222850; x=1775827650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5CVFkoDCxGsxXBj8bPmZ7vpSl4MJkw0Z6mvu33ifBL4=;
        b=UssqBtqu5NCCq0J7J5ciCFgloqln4BpjQTSBL9BdxUCdAUW2BXsOpEjANcrmcWfjsn
         Tebmrbj3/Pu0IdWmkB+rnuVRAqryVfOpU2VUI00NAkEjO/vsTtBoYuHvDzhI9z2NYCAp
         DLR2eRgbK1wyAdvOlRyZkCgdGCafY5UdRVHsF8mMkf2UEkBJHEpm+14bNiL04I/C1Ptz
         SFgHVnptOCB7kiuAZC00VQ4b5Ptu/axV4i4Muxa7MqDp0KFpHTbmuOzM4I5gmb92hiLs
         kw8HYbWwzytu57u8+9i94awOEjGhHAt4QAFRRs6g7GPAPAlZfDDFG+hOzQFAO/AOr45B
         UwtA==
X-Forwarded-Encrypted: i=1; AJvYcCXw5Hlx8rgBJ3ofL3GUxIEEIFDA8ra6KhcCNLDxQqE64hg1ZnZJVsabAmyp/IhuzvMEOAq2qu6KSKZxhoQZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwMYzxsb1ttMRIcx4iFiQWbg3eYIYvlAXIPQfGZb5qQVIpI3Wqv
	ZVRoNTGgN7huDztudG+tlkaPx+CqaBFGnqLvkkOsTmZtskkm7S3404GOVBGfHxuOU/GR428+5CP
	rUH7D5BXuda2kt888jzBjlt6HzB43LEg=
X-Gm-Gg: AeBDievD91ycNgQBS40RXkSocSdHwpjVxeoQv+URKtRYqGaWI+02MGXZ+HljwpIOXuM
	1pDvE5ARbpncXJm8sx7iulRqej3WsOsJw6gWJcI34oONi4yzFVAqMJncZ0lZ2gV6dtMLn6dN8me
	tbPHSb6hp4mw9hcH7Cics2fdCyqxzRbKQVSF27nlmwZ3BprZTHPKkipu9D5SkpcbvC01u41cV5o
	f8HqQvelzWrjYOucBp50NZkUnm18hVTaB8vY9Q+H8kCa9vZGTEiGmb/VdI/rZ54exWXHLZ9udY6
	cI9WHUE7
X-Received: by 2002:a05:690e:4146:b0:640:cccb:1fd2 with SMTP id
 956f58d0204a3-65048766844mr2643914d50.33.1775222849700; Fri, 03 Apr 2026
 06:27:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <2261072.irdbgypaU6@7950hx>
 <CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com> <3036842.e9J7NaK4W3@7940hx>
In-Reply-To: <3036842.e9J7NaK4W3@7940hx>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 3 Apr 2026 21:26:53 +0800
X-Gm-Features: AQROBzAhqUn0C4z5t47fiWttRpelo5Bwp2NUuCrYH7DZ2fW1KBFq_ETr6BE5IqE
Message-ID: <CALOAHbAx=ne-ByCXF+4ehLYX9+3a5BDjHyUn=owmEJNBFXOthg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Menglong Dong <menglong.dong@linux.dev>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	song@kernel.org, jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-2284-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: EB81F394751
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 6:26=E2=80=AFPM Menglong Dong <menglong.dong@linux.d=
ev> wrote:
>
> On 2026/4/2 21:20 Yafang Shao <laoar.shao@gmail.com> write:
> > On Thu, Apr 2, 2026 at 8:48=E2=80=AFPM Menglong Dong <menglong.dong@lin=
ux.dev> wrote:
> > >
> > > On 2026/4/2 17:26, Yafang Shao wrote:
> > > > Introduce the ability for kprobes to override the return values of
> > > > functions that have been livepatched. This functionality is guarded=
 by the
> > > > CONFIG_KPROBE_OVERRIDE_KLP_FUNC configuration option.
> > >
> > > Hi, Yafang. This is a interesting idea.
> > >
> [...]
> >
> > +/* noclone to avoid bond_get_slave_hook.constprop.0 */
> > +__attribute__((__noclone__, __noinline__))
> > +int bond_get_slave_hook(struct sk_buff *skb, u32 hash, unsigned int co=
unt)
> > +{
> > +       return -1;
> > +}
>
> Hi, yafang.
>
> I see what you mean now. So you want to allow BPF program override
> the return of all the kernel functions in a KLP module.
>
> I think the security problem is a big issue. Image that we have a KLP
> in our environment. Any users can crash the kernel by hook a BPF
> program on it with the calling of bpf_override_write().

This feature is guarded by the CONFIG_KPROBE_OVERRIDE_KLP_FUNC
configuration option, which is disabled by default. Consequently, the
user must explicitly enable this option to utilize the feature.

>
> What's more, this is a little weird for me. If we allow to use bpf_overri=
de_return()
> for the kernel functions in a KLP, why not we allow it in a common kernel
> module, as KLP is a kind of kernel module. Then, why not we allow to
> use it for all the kernel functions?

By leveraging KLP, we can rapidly deploy new features without
interrupting production workloads. Accordingly, this feature is
specifically targeted at KLP-patched functions to maintain that
seamless delivery model.

>
> Can we mark the "bond_get_slave_hook" with ALLOW_ERROR_INJECTION() in
> your example? Then we can override its return directly. This is a more
> reasonable for me. With ALLOW_ERROR_INJECTION(), we are telling people th=
at
> anyone can modify the return of this function safely.

It is unfortunate that ALLOW_ERROR_INJECTION() is incompatible with
KLP-patched functions, as this limits our ability to perform fault
injection on livepatched code

>
> WDYT?
>
> BTW, this is a BPF modification, so maybe we can use "bpf: xxx" for the t=
itle
> of this patch. Then, the BPF maintainers can notice this patch ;)

I agree with the suggestion. I will update the subject prefix to
"trace, bpf:" in the next version.

--=20
Regards
Yafang

