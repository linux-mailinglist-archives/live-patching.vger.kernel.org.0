Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD567A5D3
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 23:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjAXWdL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 17:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbjAXWdA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 17:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6395593;
        Tue, 24 Jan 2023 14:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79C3CB816E1;
        Tue, 24 Jan 2023 22:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D82C433EF;
        Tue, 24 Jan 2023 22:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674599563;
        bh=O+TDDdp7SpLSIQghWRuuMhr8V3iv3q3uTu4o8VupFKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ivDKtTkxMPIyZnXHRYqe88giy94iZBNfT1PPK12c4EddjdYTRGd2diWyoPYIrl1wV
         UuC80dSL1gTZxwArChhDeFlIobE2dIC2/nf0NsuZOyQV7MwMzzyAwPm2O3G61m6C5H
         Ske2n2UrZemcmLdD7sCaf/QdtY/5ywjm7Q0wgb96t95JDeZhu61RUs/IO6xiKdxxpl
         CM8v3VyaV/k/W9oVNyJvIqaL/+FDP+KU2qdfPHvBBafhsC3EbB00q8q6tvsF8TtTuJ
         DOVRS5113cIpt6KZFYKy/hTBMELFhclgyVfBL5iuEn7SPQK0JLDYSjVAssp9ZInaPd
         t3UHrto6SSGCg==
Date:   Tue, 24 Jan 2023 14:32:41 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20230124223241.ywbhxdrj26qfgtd6@treble>
References: <20230118204728.1876249-1-song@kernel.org>
 <20230118220812.dvztwhlmliypefha@treble>
 <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com>
 <20230120064215.cdyfbjlas5noxam6@treble>
 <57fa3069-8e7e-d204-4c78-05432156f044@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57fa3069-8e7e-d204-4c78-05432156f044@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 24, 2023 at 03:08:27PM -0500, Joe Lawrence wrote:
> > +	/*
> > +	 * For a livepatch relocation, the restore r2 instruction might have
> > +	 * been previously written if the relocation references a symbol in a
> > +	 * module which was unloaded and is now being reloaded.  In that case,
> > +	 * skip the warning and instruction write.
> > +	 */
> > +	if (klp_sym && insn_val == PPC_INST_LD_TOC)
> > +		return 0;
> 
> Hi Josh,
> 
> Nit: shouldn't this return 1?
> 
> And if you're willing to entertain a small refactor, wouldn't
> restore_r2() be clearer if it returned -ESOMETHING on error?
> 
> Maybe converting to a boolean could work, but then I'd suggest a name
> that clearly implies success/fail given true/false return.  Maybe
> replace_nop_with_ld_toc() or replace_nop_to_restore_r2() ... still
> -ESOMETHING is more intuitive to me as there are cases like this where
> the function safely returns w/o replacing anything.

Indeed, and I actually already discovered that and made such changes,
just need to get around to posting the patches.

-- 
Josh
