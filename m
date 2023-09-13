Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE31679E177
	for <lists+live-patching@lfdr.de>; Wed, 13 Sep 2023 10:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbjIMIGX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Sep 2023 04:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbjIMIGT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Sep 2023 04:06:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4A2198A;
        Wed, 13 Sep 2023 01:06:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3AEA9215EE;
        Wed, 13 Sep 2023 08:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694592374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UVXZO7W2/QCPPSKGU4H/Fe8rerhR3cSJZGyrzhYOvmk=;
        b=c03TtHJub3JTBDiTKedrTnB0QDOzSi2Gsnh8FR5Ihkc9N8R+HeZbMLOSnj0ZzzdNveD47f
        5cMbweHy0EppeoPtIdyuib6XERK/XWEoh8bu7YFwf1zvUvNCT3Hqj4lP6BhKSkJ/01PqUb
        Jga5QzIe7QA9YgzG9VuBwblqEZY0XkE=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5A20E2C146;
        Wed, 13 Sep 2023 08:06:12 +0000 (UTC)
Date:   Wed, 13 Sep 2023 10:06:12 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Alessandro Carminati <alessandro.carminati@gmail.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Nick Alcock <nick.alcock@oracle.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Eugene Loh <eugene.loh@oracle.com>,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Viktor Malik <vmalik@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-ID: <ZQFtdJEKJ9taYpA0@alley>
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
 <d385548e-9788-2814-05c9-bb0f275b233f@intel.com>
 <CAPp5cGSHdU6z2J=bUYkXMOakFzSWzjeCznTsV=DrTSvWmaqStA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPp5cGSHdU6z2J=bUYkXMOakFzSWzjeCznTsV=DrTSvWmaqStA@mail.gmail.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-09-12 16:18:00, Alessandro Carminati wrote:
> <aleksander.lobakin@intel.com> ha scritto:
> > From: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
> > > sample from new v3
> > >
> > >  ~ # cat /proc/kallsyms | grep gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> > >  ffffd0b03c050960 t gic_mask_irq
> > >  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
> >
> > BTW, why normalize them? Why not just
> >
> > gic_mask_irq@drivers/irqchip/...
> >
> > Aaaaand why line number? Line numbers break reproducible builds and also
> > would make it harder to refer to a particular symbol by its path and
> > name since we also have to pass its line number which may change once
> > you add a debug print there, for example.
> > OTOH there can't be 2 symbols with the same name within one file, so
> > just path + name would be enough. Or not?

I am afraid that there can be more symbols with the same name in a
single source file. For example, static variables defined inside
functions:

$> cat >test-duplicate-symbols.c <<EOT
#include <stdio.h>

void a(void)
{
	static int duplicate_var = 100;

	printf("%s: %d\n", __func__, duplicate_var);
}

void b(void)
{
	static int duplicate_var = 200;

	printf("%s: %d\n", __func__, duplicate_var);
}

int main(int argc, char *argv)
{
	a();
	b();
}
EOT

$> gcc -o test-duplicate-symbols test-duplicate-symbols.c

$> ./test-duplicate-symbols 
a: 100
b: 200

$> objdump -t test-duplicate-symbols | grep duplicate
test-duplicate-symbols:     file format elf64-x86-64
0000000000000000 l    df *ABS*  0000000000000000              test-duplicate-symbols.c
0000000000402018 l     O .data  0000000000000004              duplicate_var.2190
000000000040201c l     O .data  0000000000000004              duplicate_var.2195


> Regarding the use of full file paths and line numbers for symbol decoration,
> it indeed provides the highest level of uniqueness for each symbol.
> However, I understand your point that this level of detail might be more than
> necessary.
> 
> This approach was implemented in response to a specific request expressed in
> the live-patching list, and I wanted to ensure we met those requirements.
> I am open to revisiting this aspect, and I am willing to accommodate changes
> based on feedback.

Yeah, livepatching needs to be able to find any symbol which might
need to be accessed from the livepatch.

The line number is perfectly fine for livepatching because there
is 1:1:1 relationship between the kernel sources, binary, and
livepatch.

And it might be even useful for the tracing. It helps to find
and investigate the traced code easily.

Hmm, I understand that it complicates the live for the trace
tooling. I wonder if we could allow searching the symbols
with a pattern, e.g. the bash style
"duplicated_symbol_name-source_file_c*"


> If you believe that simplifying the format to just path + name would be more
> practical, or if you think that eliminating line numbers is a better choice
> to avoid potential issues while debugging builds, I'm open to considering
> these adjustments.
> Additionally, I've interpreted and implemented Francis's suggestion as making
> the separator a configurable option, but maybe a proper format string here,
> would be more appropriate.

Please, do not make the format configurable. I think that it will
cause more harm than good. It would make the life more complicated
for developing tracing tools.

The tools would need to support all the formats as well. Or they
would support only some and will not be able to trace kernels
with the others. Both is bad.

Anyway, thanks a lot for working on this.

Best Regards,
Petr
