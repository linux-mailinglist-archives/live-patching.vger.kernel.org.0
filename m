Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2721564628
	for <lists+live-patching@lfdr.de>; Wed, 10 Jul 2019 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfGJM2K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Jul 2019 08:28:10 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33876 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfGJM2K (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Jul 2019 08:28:10 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so1947630otk.1;
        Wed, 10 Jul 2019 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FNqx+M2R51JE04Z34tCRtE1I2zuoMlX/VVUP9urQ/g=;
        b=cRN+1ygji015bntIuNNMqDL5Hhvz9UEFPR3wPkgOd9pZ0sb8Pp6JS2cxZ/6Ck9aJZ6
         slcqy2QAylFSWD4AZkxn5Bpfo9f3TuRqaNv1y8ffzX6ubNCA+Udge0FdoXinLWh+NVsS
         VCnGASm/tVS8oWXMoqO9ufoKto1DbMJGmEZfUyai1gHAVkJYHxZjBQq02gLm9aN4oZcL
         zuPGYJsuDgJO1+gJexcT2ymPZob4d6bKWcPLuIsqByOSS5+oq1iYO66/C7rE+oIKCYQ4
         Oe+nVSxEfPTEuYVebEkSW4FfE2PGDL+uov5nucedyg1dhivtPIfCXoUyz9U+Yn8wbvzo
         ToUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FNqx+M2R51JE04Z34tCRtE1I2zuoMlX/VVUP9urQ/g=;
        b=avJnukx/EgcaSkaV0kxOkES0PR2itp8wKNc96nl3XTQG8dUezggB+s3KdJLkivkLSj
         Ev4KLRdJ3Pc+p1Z4M56lcEfBJnEhmbYVwtXhcQYX2uyvg4ggbm8hbCriy75IBF+ERGP2
         U7hdws6MBs/xB56XqyjwW4tJSYxN3z4ur4aQwo7uj28pLInTZ1JOeqyRV3xxrhlkfLr/
         zcVgDd4HrtO4o/qdl9IBzAB3AKGoiLxpSsjWpkEpcY0yTkPOjn5cKuyWpXsOEK+nEqpC
         gS8NEjQ8QivvgDO6gfse2ni4TPI/RFgO733szeHnoj9PwNliM5qYOPUm/4eq/nExCF/1
         2utA==
X-Gm-Message-State: APjAAAXQ99plM7X3eSrrPbHvf+c9qfOjdELn2jOqn38FxM4yQLwX3APx
        qu0zWGLZ3TK3rh6Thq6URayJ+IyDzHzJl9aLh8E=
X-Google-Smtp-Source: APXvYqzEWNBdZe9q7RPZCtKpqe0c0GbIay/OZ2Z1mJrHeMez83o2JTAzAdGZ3NJ3TfKDfeJ7z6jA9RE3ZCouyFwvx6s=
X-Received: by 2002:a9d:6194:: with SMTP id g20mr2471325otk.149.1562761689474;
 Wed, 10 Jul 2019 05:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190208150826.44EBC68DD2@newverein.lst.de> <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
 <20190311114945.GA5625@lst.de> <20190408153628.GL6139@lakrids.cambridge.arm.com>
 <20190409175238.GE9255@fuggles.cambridge.arm.com>
In-Reply-To: <20190409175238.GE9255@fuggles.cambridge.arm.com>
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
Date:   Wed, 10 Jul 2019 15:27:58 +0300
Message-ID: <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
Subject: Re: [PATCH v8 0/5] arm64: ftrace with regs
To:     Will Deacon <will.deacon@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, Torsten Duwe <duwe@lst.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 9, 2019 at 8:52 PM Will Deacon <will.deacon@arm.com> wrote:
>
> On Mon, Apr 08, 2019 at 04:36:28PM +0100, Mark Rutland wrote:
> > On Mon, Mar 11, 2019 at 12:49:46PM +0100, Torsten Duwe wrote:
> > > On Wed, Feb 13, 2019 at 11:11:04AM +0000, Julien Thierry wrote:
> > > > Hi Torsten,
> > > >
> > > > On 08/02/2019 15:08, Torsten Duwe wrote:
> > > > > Patch series v8, as discussed.
> > > > > The whole series applies cleanly on 5.0-rc5
> > >
> > > So what's the status now? Besides debatable minor style
> > > issues there were no more objections to v8. Would this
> > > go through the ARM repo or via the ftrace repo?
> >
> > Sorry agains for the delay on this. I'm now back in the office and in
> > front of a computer daily, so I can spend a bit more time on this.
> >
> > Regardless of anything else, I think that we should queue the first
> > three patches now. I've poked the relevant maintainers for their acks so
> > that those can be taken via the arm64 tree.
> >
> > I'm happy to do the trivial cleanups on the last couple of patches (e.g.
> > s/lr/x30), and I'm actively looking at the API rework I requested.
>
> Ok, I've picked up patches 1-3 and I'll wait for you to spin updates to the
> last two.

Ok, I see that patches 1-3 are picked up and are already present in recent
kernels.

Is there any progress on remaining two patches?
Any help required?

Thanks,
Ruslan
