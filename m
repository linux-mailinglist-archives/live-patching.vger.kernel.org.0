Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95C355D619
	for <lists+live-patching@lfdr.de>; Tue, 28 Jun 2022 15:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiF0Qcx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 12:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbiF0Qco (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 12:32:44 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6D0B492
        for <live-patching@vger.kernel.org>; Mon, 27 Jun 2022 09:32:43 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m184so5775503wme.1
        for <live-patching@vger.kernel.org>; Mon, 27 Jun 2022 09:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3jWqe5eCEvfhJ7SMk4jmfVBzaJ6AjX6eIUnqn4WhHcw=;
        b=XVc9E0UydcgtLVpzee18YUE9wICJ2T/ZGKJI2aIKDSZ0FG2od9hCMeDuQ04H0LHste
         EMlYDFtHmqQHE5QTJzqXpgfexBrPEb8s/gNrhGLcVlknqbf5WVjUoLqoF4/auGb1d2pp
         KvCmBZx6+xHU2kGHRslJarja7ML5hE8qjc9vYEWtYm6gDaLMyKKY/CNS1qDDYMmNrf2q
         eJGzNf6Kt2xl35zFybppKqqjGgCbEToH9xB5OnUM9RQIoqOID+E6UxNMgQJxGaGbAiK+
         A9lg9ufuLtyP3v79JJ+7OzMGSKg+ItpegL4oXNOvBdIBkW74CZhBWA2w3qXGGoNk6Q2Y
         GrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3jWqe5eCEvfhJ7SMk4jmfVBzaJ6AjX6eIUnqn4WhHcw=;
        b=y2+JR7oV3F1CXzIS1njgCBCEBaRsuLOvWbhPeVox3+nGJns+SeHeJCEQaPO1oiIJs4
         c6wj0zh62nnP4jdAuSs5bSKmazoIl/QRhHniMk8zzTm1yeKubv0be+UNelzugaXCMgq3
         hoswvKg8Fi9KVNSN+i6snU3Kf2ktNyIA1w0TcUpCNkXR24gFUbvjxWfS1EFUpIQar9MQ
         gEsExinV1j3+Zw99vY2HvUGKsqG/jRMUG1p29kA4ic0VvyFUzjSeSIRShxbZ8ZrVyfJk
         8qMOOLlk1OQXMKHxGd/BM1BJN6tjMMmZWgvccC+w5Dm3+40oSyx+lAu87X42Fmam+IVK
         GNAg==
X-Gm-Message-State: AJIora/wuhezW5HOZUefrNW7Pd/5u6FhcjMgrK1vw0DCgAoOuDaGXHEU
        QZHWmpGfg5f1KW3bbkp84PaFXcDPLobSwDXq+ihNwQ==
X-Google-Smtp-Source: AGRyM1t48nYJVTT2qNAqd3qaLOiynSoa4TcaU+Vs4a6qOvjq1erfTLSCVvuvbMMR2hkQh4b41MolwKgSaJZvfs85Jjs=
X-Received: by 2002:a05:600c:4081:b0:3a0:47c4:8dd0 with SMTP id
 k1-20020a05600c408100b003a047c48dd0mr9768995wmh.178.1656347561570; Mon, 27
 Jun 2022 09:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck> <66545c21-cfcf-60eb-4acf-39be99520369@linux.microsoft.com>
 <YrgkdBtbFmOvKJpX@FVFF77S0Q05N> <b7f62c2e-b2ef-1528-d126-b2e0c001a7c4@linux.microsoft.com>
In-Reply-To: <b7f62c2e-b2ef-1528-d126-b2e0c001a7c4@linux.microsoft.com>
From:   Kalesh Singh <kaleshsingh@google.com>
Date:   Mon, 27 Jun 2022 09:32:30 -0700
Message-ID: <CAC_TJveqCTToimvrrTrEcRAxERL0EW+61PxS9emb-u51Eo4Eug@mail.gmail.com>
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Jun 26, 2022 at 9:33 PM Madhavan T. Venkataraman
<madvenka@linux.microsoft.com> wrote:
>
>
>
> On 6/26/22 04:18, Mark Rutland wrote:
> > On Fri, Jun 24, 2022 at 12:19:01AM -0500, Madhavan T. Venkataraman wrote:
> >>
> >>
> >> On 6/23/22 12:32, Will Deacon wrote:
> >>> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
> >>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>>>
> >>>> I have synced this patch series to v5.19-rc2.
> >>>> I have also removed the following patch.
> >>>>
> >>>>    [PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
> >>>>
> >>>> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
> >>>> yet. This patch will be added in the future once Objtool is enhanced to
> >>>> provide stack validation in some form.
> >>>
> >>> Given that it's not at all obvious that we're going to end up using objtool
> >>> for arm64, does this patch series gain us anything in isolation?
> >>>
> >>
> >> BTW, I have synced my patchset to 5.19-rc2 and sent it as v15.
> >>
> >> So, to answer your question, patches 1 thru 3 in v15 are still useful even if we don't
> >> consider reliable stacktrace. These patches reorganize the unwinder code based on
> >> comments from both Mark Rutland and Mark Brown. Mark Brown has already OKed them.
> >> If Mark Rutland OKes them, we should upstream them.
> >
> > Sorry for the delay; I have been rather swamped recently and haven't had the
> > time to give this the time it needs.
> >
> > I'm happy with patches 1 and 2, and I've acked those in case Will wants to pick
> > them.
> >
> > Kalesh (cc'd) is working to share the unwinder code with hyp, and I think that
> > we need to take a step back and consider how we can make the design work
> > cleanly with that. I'd had a go at prototyping making the unwinder more data
> > driven, but I haven't come up with something satisfactory so far.
> >
> > It would be good if you could look at / comment on each others series.
> >
>
> I will review Kalesh's unwinder changes.

Thanks Mark, I'll take a look.

Madhavan, I'm in the process of preparing a new version. Let me rebase
on your first 2 patches and resend, so you can look at that version
instead.

Thanks,
Kalesh

>
> Thanks.
>
> Madhavan
