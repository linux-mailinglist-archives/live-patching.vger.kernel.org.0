Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B2315617
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 19:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhBISgX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 13:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbhBISYl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 13:24:41 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42461C061797
        for <live-patching@vger.kernel.org>; Tue,  9 Feb 2021 10:09:58 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id r23so21745431ljh.1
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 10:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QlrUv98m3txRxRypr42z/6B1CjH59DrwYQO+A25z6Ck=;
        b=MZqRHNGl5UVD3LNyPZVDCWmVu1CVaaT0SkbucSwyAjEe/Mgs3FAaaz/CYo1niXBBcy
         KBQ/fl3O67N55M3ZI10bmnNoKdTzh9GaIddvF4dOrNaknRSt0e+Hsy8KYXW86Rpx9Fq7
         2DGJBLtxqcfaiS+z3Sgrzd8OZZGTIGps112zQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QlrUv98m3txRxRypr42z/6B1CjH59DrwYQO+A25z6Ck=;
        b=SaPYFnZILhowthmoHvfEnT9SZcLN8WgOkdRYv3IUDubb6mwnl9b0gA5gVoXPKRqAWP
         Kq2/otc4mxWLoC5iadJlk6PnwNvR4Pe9o4GyZ1MWLxCw+YajWNiBJMp+BvmHflrp86RN
         Amf8iAfgcaY51bHSfjIKggCCDG5h/uKE48qyfVc65ZDM+kRLu+ibzqQrMEBpSCuZwkIh
         3Gk7zUiFl+ooXYAvQOZuwqARuYtYXQXLGLDhZIm+WKrq5G0zYc/o0wuv963ewyzbsrIE
         GWMZPrDVq+iY2gNvluSeiGXFwWdE0CCzCXPCDswjwQ0x1fi/R7Sl/Ga6icFzlQysPJED
         AwSA==
X-Gm-Message-State: AOAM5339eieosvHwPb6CPqBByulsoc8SCwk93mNUdc7XOWpbPzIP0cRV
        cyK90GeOI69FLkUSWzjsxtRu+U0K0AuW2Q==
X-Google-Smtp-Source: ABdhPJyzCSr9VwCVjU/eYmTtI9GZ2AjO1wRswi6sfYwfnQ7WUB2Ptxna0gXLtQSPVSZrA7PcIgWhPQ==
X-Received: by 2002:a2e:6f1e:: with SMTP id k30mr15282406ljc.164.1612894196083;
        Tue, 09 Feb 2021 10:09:56 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id n16sm1310385lfe.13.2021.02.09.10.09.54
        for <live-patching@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 10:09:54 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id a17so23646778ljq.2
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 10:09:54 -0800 (PST)
X-Received: by 2002:a2e:720d:: with SMTP id n13mr15733268ljc.220.1612894193564;
 Tue, 09 Feb 2021 10:09:53 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQK-qdE6mHUogeaQo9Av_58cLptosmfUVmdMzW7gJn5UVw@mail.gmail.com>
 <73175691-4AE1-496D-80D1-DC85AE1E9C27@amacapital.net>
In-Reply-To: <73175691-4AE1-496D-80D1-DC85AE1E9C27@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 10:09:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgNXnmxjm+kK1ufjHfQPOBbuD5w3CTkSe0azF3NNWEHHQ@mail.gmail.com>
Message-ID: <CAHk-=wgNXnmxjm+kK1ufjHfQPOBbuD5w3CTkSe0azF3NNWEHHQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 9, 2021 at 8:55 AM Andy Lutomirski <luto@amacapital.net> wrote:
>
> Or we hack up #CP to handle this case. I don=E2=80=99t quite know how I f=
eel about this.

I think that's the sane model - if we've replaced the instruction with
'int3', and we end up getting #CP due to that, just do the #BP
handling.

Anything else would just be insanely complicated, I feel.

             Linus
