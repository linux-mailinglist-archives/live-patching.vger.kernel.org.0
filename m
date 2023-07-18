Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEEA757124
	for <lists+live-patching@lfdr.de>; Tue, 18 Jul 2023 03:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGRBBW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jul 2023 21:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGRBBW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jul 2023 21:01:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E3A6;
        Mon, 17 Jul 2023 18:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C3C6134B;
        Tue, 18 Jul 2023 01:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446A2C433C7;
        Tue, 18 Jul 2023 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689642080;
        bh=sYoB8EsYHp3bPyDDl82q/NWRIoZwpXBQ2TK6HH5fWxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h+bztgsYFyCfwn61V/O/SSstG4emcnkd0rwEz3blGoOfaPLw//fwTx2kINkVanA0Z
         S9vdvl5X5WKhhrI/Nkqnj6PaybZZ0tmAHYJtt3aFNEvzuoqKuRWjeXVK7waOuYpBWj
         6DiJD1FVcy8t7Lme8Fh+iPYILfgmE18VRQdB3dbTJSFJYYCyKyPed9N/wQw1wp72py
         sYyn01wXYbvUtgS0jgxlOqvTh1TQvrrWLHc7j9c/g2xDGENKnOZzKZ4wGfgoMuKwiJ
         r7dVLPstrM5Q4tdfxoRgoHW7+rBztor6eCp9xiPnCAckGaCW335Hcyt6OlIDHYv5lh
         zphcDbo8Zuntg==
Date:   Tue, 18 Jul 2023 10:01:15 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alessandro Carminati <alessandro.carminati@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Nick Alcock <nick.alcock@oracle.com>, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-Id: <20230718100115.ac5038d243105a46d279b664@kernel.org>
In-Reply-To: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
References: <20230714150326.1152359-1-alessandro.carminati@gmail.com>
        <20230717105240.3d986331@gandalf.local.home>
        <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 17 Jul 2023 09:50:25 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> On Mon, Jul 17, 2023 at 10:52:40AM -0400, Steven Rostedt wrote:
> > Honestly, I think the "_alias_<some-random-number>" is useless. It doesn't
> > give you any clue to what function you are actually attaching to. 
> 
> Agreed.

+1 :)

> > There's
> > been other approaches that show module and/or file names. I know there's
> > still some issues with getting those accepted, but I much rather have them
> > than this!
> > 
> > See: https://lore.kernel.org/all/20221205163157.269335-1-nick.alcock@oracle.com/
> 
> Yes, please coordinate with Nick and review each other's work, now we
> have two separate efforts with different reasons but hopefully we'll
> come back with one unified solution.
> 
> Please Cc live-patching also, as they had suggested before just to
> provide the file filename + line number, that'll make it even more
> valuable.

I want to involve BTF, that is currently only support looking up function
by name. This alias is currently decouple from the BTF, but BTF name is
also need to be updated so that we can lookup BTF from the alias name.

Thank you,


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
