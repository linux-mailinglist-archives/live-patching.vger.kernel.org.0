Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A197444A4B
	for <lists+live-patching@lfdr.de>; Wed,  3 Nov 2021 22:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKCVgT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Nov 2021 17:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCVgS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Nov 2021 17:36:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34820C061714
        for <live-patching@vger.kernel.org>; Wed,  3 Nov 2021 14:33:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so3528913pgc.6
        for <live-patching@vger.kernel.org>; Wed, 03 Nov 2021 14:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vrz+tdiTTOp8szNJ91rvZ9PnjQkFO5LZUDNo6iz8BFk=;
        b=lrlsl0kWNH6gBlT7Fehk8GvFi1ohYeIPuGJC8y0Wtsn21/AFqufl0BsSeljKPJOgqo
         QRBPr0w/Qp0WeOw9SMpGdFtR6bKT9MiFMm4l7rc7D7JPvLuMQXt5wg6s/zG+xRBW2JGD
         DJk+sNZrRd68Jp6V9WzgNlDiqO1rA+Z8f7k3mowUuZK/h7Rx9B8/G4XTcS4ogOJantCq
         8P8e5woqUzDLGPFMgnKjcxwTAnTIK70AJTYDjAF7HnWL1Ou5dvDVY9Fiw9rtZkHLmBeL
         5UknEF+vmqL9qUg2cNP+nZzWRqr9oqXNFUu7H41tZ90CTaV0T884XMzKjfBfjtMJoW25
         TAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vrz+tdiTTOp8szNJ91rvZ9PnjQkFO5LZUDNo6iz8BFk=;
        b=6oyrTQ9/A9YV73WNMyOLzEt4dt1iK8+n2+VTm7UC1fIHT7NQR/siX/728ulEqM8/Uj
         jkfW2s/iIfphoHKcZWQAxKPt2JAuaO2dM2fBmi+62Yr0tJnWwZJ+Ett29DAiazPoz9nm
         losA8yH/TuJ8H1RiMjlzBMsZiyLrNC2EDP+IZc4iC8WfhH+TWQZbmLO5fELfIxJ9u0JY
         d1yF5gpOsmH27dKmzkaK3SeN0DnA1vgbVmFPD2M0G6gHqWhhQevr/euLk9GLTV42FMNE
         9pbwoe2kvUeGRMfNH/+5v8ysOyr6n+Eu64N+LC5LkIwdmeQPnpGCgw07zq3rTUkV0TOY
         WOuQ==
X-Gm-Message-State: AOAM531NWPwQL7cj3Y6+kRGRNUHMfM09TaV9aFfUkVHyaJ1NB44ojyih
        V6jT9hL/zhheSIE85Ic0WaQUCK9jbUc=
X-Google-Smtp-Source: ABdhPJyg0R3/Q3bIGPKfyNNRvH9PP7swCV9K3IQVMYv+zNfLa8JDaYKVoxGJ4Pa5OL9U2eRghuj/Ig==
X-Received: by 2002:a63:c:: with SMTP id 12mr35942364pga.477.1635975220204;
        Wed, 03 Nov 2021 14:33:40 -0700 (PDT)
Received: from vpn-10-50-19-212.sea19.amazon.com ([54.240.196.175])
        by smtp.googlemail.com with ESMTPSA id a140sm3192789pfd.150.2021.11.03.14.33.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Nov 2021 14:33:39 -0700 (PDT)
Message-ID: <664dc34bc9343e761d2f1ea701aa682778913073.camel@gmail.com>
Subject: Re: ppc64le STRICT_MODULE_RWX and livepatch apply_relocate_add()
 crashes
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Russell Currey <ruscur@russell.cc>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date:   Wed, 03 Nov 2021 14:33:39 -0700
In-Reply-To: <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
References: <YX9UUBeudSUuJs01@redhat.com>
         <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Russell,

On Mon, 2021-11-01 at 19:20 +1000, Russell Currey wrote:
> On Sun, 2021-10-31 at 22:43 -0400, Joe Lawrence wrote:
> > Starting with 5.14 kernels, I can reliably reproduce a crash [1] on
> > ppc64le when loading livepatches containing late klp-relocations
> > [2].
> > These are relocations, specific to livepatching, that are resolved
> > not
> > when a livepatch module is loaded, but only when a livepatch-target
> > module is loaded.
> 
> Hey Joe, thanks for the report.
> 
> > I haven't started looking at a fix yet, but in the case of the x86
> > code
> > update, its apply_relocate_add() implementation was modified to use
> > a
> > common text_poke() function to allowed us to drop
> > module_{en,dis}ble_ro() games by the livepatching code.
> 
> It should be a similar fix for Power, our patch_instruction() uses a
> text poke area but apply_relocate_add() doesn't use it and does its
> own
> raw patching instead.
> 
> > I can take a closer look this week, but thought I'd send out a
> > report
> > in case this may be a known todo for STRICT_MODULE_RWX on Power.
> 
> I'm looking into this now, will update when there's progress.  I
> personally wasn't aware but Jordan flagged this as an issue back in
> August [0].  Are the selftests in the klp-convert tree sufficient for
> testing?  I'm not especially familiar with livepatching & haven't
> used
> the userspace tools.
> 

You can test this by livepatching any module since this only occurs
when writing relocations for modules since the vmlinux relocations are
written earlier before the module text is mapped read-only.

- Suraj

> - Russell
> 
> [0] https://github.com/linuxppc/issues/issues/375
> 
> > 
> > -- Joe
> 
> 

