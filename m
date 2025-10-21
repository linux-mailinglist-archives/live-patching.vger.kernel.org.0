Return-Path: <live-patching+bounces-1785-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34666BF7944
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 18:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BF064004EC
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 16:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA283451DA;
	Tue, 21 Oct 2025 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TK+cQH88"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C333451B5
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062794; cv=none; b=Nz9ZLUP8WGc/zM5Asf0aS/zY/fysf2W/qETLzklT6ZPPrSb43JaZCDmuPDpwZpjJM6EZh+CwpB9usA6gDQ+5akS+8TZLzcGu7BJ/2huABnGOxt5wDYZOz0Z6uM2KiPd8IzELsBj16TXi8/DuhpageWADz0sxPaWbQtpiRmQii+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062794; c=relaxed/simple;
	bh=q3CBJOYmeg5M7rjM1bpNPDtUKbS4NHhnHM5pkntvP4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hsEw/Eo3lo6wCDxCE2dbKV1wIAD8jmvEPKUwiGyXBhNIr3CgqrMixcsZXIOIZmNRFF63BpmTlC+x/dcBEg14xAGa4VDxovdq+j9j3R+p1rmJJ/g6bFCEkUghDffnHq/ikH46uLXDv0nYfOV/W4KXRtOWzWlMRMgnrLdrQFDn1vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TK+cQH88; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C132CC4CEF1
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761062791;
	bh=q3CBJOYmeg5M7rjM1bpNPDtUKbS4NHhnHM5pkntvP4g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TK+cQH88zpVdfZS2tgSKfL3TfQ25Qnzbfipxo0G8NMgRzdefOGlqHl4hAHLIUyEaN
	 nrnYKxYvm2sRr3aHbpKkB+A5XC30nld4aQs6jZd8x8siYU9h2zD8BBJbPKRHdSsDqh
	 mv3H3A/CFHOXbyFTys6gnvsfrFtNIJhPchxgYMuSQxi9pLp3z4Ew0LX8Vasb/a6lOe
	 5afXCVThZrbRW4j1BD8ikmtk4ncP+nGueoUJixssEh1HUT8IiET2q5RX827NUf0Cck
	 faMVZiP4IF8q7Eiglb9glg5ZS94znezoB/8Q56UigHFWlw8apaOQp3fHJgEdapsnCH
	 MhqOdPNPPunTw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87d8fa51993so58050786d6.1
        for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 09:06:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXvHBNNScoIH97hfq8vJEzhsdEAtDCFU52F7qjoanQQ3LMdQ1ZW1B7BKUc+RO90RC5JiVgCRq61XmGJaWIR@vger.kernel.org
X-Gm-Message-State: AOJu0YyI0YGu5t2s2kZy0OzSTEI4T4/8bvYxHwpOdYQpJy15xTQRrKi8
	fhp56PxlKCkPjTh+o71Is3XOGUeq3OMpgJhWRbpdyf33jpEOrWWSLTT2ZyzSMIg/wuXSTtwh0h3
	AOPv33DHkv1kp9Y4PGJoDUBTdW0xag8g=
X-Google-Smtp-Source: AGHT+IE/7j4V3Y6HlyyEMnOiKdO4+Slbw3fhb7i1k4iq4cw1DN3bZBtw7mt3mApYF7dF8gwXdcyol51iol+pnhcHAAs=
X-Received: by 2002:ad4:5cc1:0:b0:878:ee25:427d with SMTP id
 6a1803df08f44-87c20648fc1mr214453996d6.59.1761062790982; Tue, 21 Oct 2025
 09:06:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com> <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com> <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com> <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
 <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com> <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
 <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com> <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
 <20251021100956.4c64272c@gandalf.local.home>
In-Reply-To: <20251021100956.4c64272c@gandalf.local.home>
From: Song Liu <song@kernel.org>
Date: Tue, 21 Oct 2025 09:06:19 -0700
X-Gmail-Original-Message-ID: <CAHzjS_sORKhsQzpSE4HRJSj9YjN7tS8wVPvjTrBaGxc9Unhthg@mail.gmail.com>
X-Gm-Features: AS18NWBhhLNHvXZp522SqPbfRZf7Kni36avxe8w3O2vXMlvGoIoGKMcdJmLOjMs
Message-ID: <CAHzjS_sORKhsQzpSE4HRJSj9YjN7tS8wVPvjTrBaGxc9Unhthg@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Song Liu <song@kernel.org>, Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, 
	Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 7:09=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 20 Oct 2025 23:07:26 -0700
> Song Liu <song@kernel.org> wrote:
>
> > commit a8b9cf62ade1bf17261a979fc97e40c2d7842353
> > Author: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > Date: 1 year, 9 months ago
> > ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default
>
> Hmm, this is a work around. I wonder if we can make this work with ARGS a=
s
> well? Hmm. I'll have to take a look when I get a chance.

Given both ftrace_caller and arch_prepare_bpf_trampoline are created
per arch, I think it is possible. But I guess it may require quite some wor=
k
to update and test each architecture?

Thanks,
Song

