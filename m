Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF8859473C
	for <lists+live-patching@lfdr.de>; Tue, 16 Aug 2022 01:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354607AbiHOXzA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Aug 2022 19:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355356AbiHOXv5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Aug 2022 19:51:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC64C915C8;
        Mon, 15 Aug 2022 13:16:39 -0700 (PDT)
Received: from zn.tnic (p200300ea971b988d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:988d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BB2E01EC02AD;
        Mon, 15 Aug 2022 22:16:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660594593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KMD5ZZW0UGq2Obs996tfjGpJxzdAX0qHGDYWDHvQl+Q=;
        b=L0QhKbmGsK+x7YnEkJO3Efs8BnoHyjMhN6fVG8HyEAb+v6OPMY5NRRmwfr1N+wTC4qwX+M
        KR558BiStQ1xGsTbFHpB+zRz0BtpTb3YSrsxi+cGm36DHMlDsnCXuM26DderQLFaZ3r760
        aF1onIFyJBQlok+JIWgrfndBo46rZbQ=
Date:   Mon, 15 Aug 2022 22:16:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: ftrace regression with CONFIG_UNWINDER_FRAME_POINTER
Message-ID: <YvqpnfM9ZdRO6oXa@zn.tnic>
References: <20220815195828.GE3948@sventech.com>
 <20220815160646.0dca7227@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220815160646.0dca7227@gandalf.local.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 15, 2022 at 04:06:46PM -0400, Steven Rostedt wrote:
> On Mon, 15 Aug 2022 12:58:28 -0700
> Johannes Erdfelt <johannes@erdfelt.com> wrote:
> 
> > I recently ran across an oops with ftrace when using the frame pointer
> > unwinder. It does not affect Linus' tree (tested 6.0-rc1), but it does
> > affect 5.15.60 and 5.10.136 (at least, have not tested other kernels).
> > 
> > It appears to be related to the recently merged retbleed mitigations,
> 
> If you believe this, then Cc those that are involved with those
> mitigations, which I did.

Sounds like this one:

https://lore.kernel.org/all/Yu2H%2FRdg%2FU4bHWaY@quatroqueijos/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
