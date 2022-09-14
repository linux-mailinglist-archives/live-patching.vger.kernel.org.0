Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33E85B7DCE
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 02:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiINAM1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Sep 2022 20:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiINAMZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Sep 2022 20:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1215AA2E;
        Tue, 13 Sep 2022 17:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD2CDB81197;
        Wed, 14 Sep 2022 00:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647DEC433D6;
        Wed, 14 Sep 2022 00:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663114342;
        bh=PkSh2//wMMp1MucFJs9CmlOv4o1oTLiq6JeiANe5BEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AeeDYlynyt1LJBaJ00Iv8XZJT10JWjMT0mMUqrTKdFOuLS6T/Q+8fpljbd1GOBeaM
         svEGoLsrMaa0ItXAYwG0HoHZwQ7vSF6x5IzXZrpvqEuL7knNH7XINDQov0BAn42rd0
         BSqGyhaU7mwqMx7slEz1YhuLCGA5XCpyfFzzkERDDIbTmX7CeojbnJna9/sFXzg4vX
         tw09jGuizzgFnYcTuWVnb1jpaOVYWBQZWowJbVldBmU6Kd0qTbeTRQw3YKPS9SX8Rh
         7qcnz0bxNiF9EpzRaINR/0rVnn3ph7Lvuk6h5wZumNm6w85W4RaEWu4NpWL9nwUhTO
         3dcW/kYdRPmFw==
Date:   Wed, 14 Sep 2022 01:12:05 +0100
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Indu Bhagat <indu.bhagat@oracle.com>
Cc:     linux-toolchains@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, "Jose E. Marchesi" <jemarch@gnu.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [RFC] Objtool toolchain proposal:
 -fannotate-{jump-table,noreturn}
Message-ID: <20220914001205.ygvmwya5wcawcodj@treble>
References: <20220909180704.jwwed4zhwvin7uyi@treble>
 <9f01a8b9-9ec6-6759-ba14-ee529a5b973a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f01a8b9-9ec6-6759-ba14-ee529a5b973a@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 13, 2022 at 03:51:44PM -0700, Indu Bhagat wrote:
> Curious to know what all features of objtool rely on the need to reverse
> engineer the control flow graph. Is it a larger set or it is only for ORC
> generation ?

Objtool features which rely on the CFG:

- Frame pointer rule validation (when using
  CONFIG_UNWINDER_FRAME_POINTER)

- ORC metadata generation

- Intel SMAP rule validation - ensures EFLAGS #AC is only set during
  usercopy

- "noinstr" rule validation - ensures no instrumentation/tracing
  functions are called in certain critical sections

-- 
Josh
