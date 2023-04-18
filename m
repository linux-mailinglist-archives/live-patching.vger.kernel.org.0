Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564106E5819
	for <lists+live-patching@lfdr.de>; Tue, 18 Apr 2023 06:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjDREbe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 Apr 2023 00:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjDREbe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 Apr 2023 00:31:34 -0400
X-Greylist: delayed 555 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Apr 2023 21:31:30 PDT
Received: from mail.namei.org (namei.org [65.99.196.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC4BA8
        for <live-patching@vger.kernel.org>; Mon, 17 Apr 2023 21:31:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.namei.org (Postfix) with ESMTPS id 8B3DB16A;
        Tue, 18 Apr 2023 03:53:56 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 8B3DB16A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
        t=1681790036; bh=YVWWlyDu46RIfavMfxlom6Tyhbyv5hFbXw8/AVuBQaU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=HKGEalgXcCuIGXxPhrbRczg8DbVAqBfQ+ncCufj7fVP+HCcwo4zar5MGjwSUOF54N
         U8dPBQ8SX0A568FDX3yYjY8yJNCjHdoNF9xUy+3O1MPQW272MNnoOCZD3Is+FLRsxR
         fJFlWXjsa6QkhHGjVqQKpjdx53NheMkhYm1XvG1Q=
Date:   Mon, 17 Apr 2023 20:53:56 -0700 (PDT)
From:   James Morris <jmorris@namei.org>
To:     Mark Rutland <mark.rutland@arm.com>
cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        madvenka@linux.microsoft.com
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
Message-ID: <9cb0235-2f8-adce-6ac-681ce49db3c@namei.org>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz> <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 14 Apr 2023, Mark Rutland wrote:

> I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
> get in contact with anyone looking at the arm64 userspace side (e.g.
> klp-convert).
> 
> I have some topics which overlap between live-patching and general toolchain
> bits and pieces, and I'm not sure if they'd be best suited here or in a
> toolchain track, e.g.
> 

> I've Cc'd Nick, Jose, and Miguel, in case they have thoughts.


Adding Madhavan, who is implementing the kernel code.



-- 
James Morris
<jmorris@namei.org>

