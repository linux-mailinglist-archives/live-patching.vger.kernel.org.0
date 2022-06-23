Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D483558792
	for <lists+live-patching@lfdr.de>; Thu, 23 Jun 2022 20:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiFWSbA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Jun 2022 14:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbiFWSat (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Jun 2022 14:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E9081C5B;
        Thu, 23 Jun 2022 10:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5C261F61;
        Thu, 23 Jun 2022 17:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96489C3411B;
        Thu, 23 Jun 2022 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656005550;
        bh=xS5bTc1MsmHGImv72JQWAcFG10Epd36XcMvUP2BXrNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwXAe0J7Ahxl51Q2WLwL/uSc4cevEKW5A/ASz4goNqi+H7gql9mC0MvLlYbfZCYRf
         IAf7XJcBbh1mnkplTk3CA4+r1vZt7T4+xjiif2UW6th6RYBRynU3Of8KsM8XseZI43
         qyUIrj7E/HwmHrFN8I2etEOpTDo7C0Z2YJIHwQlt1ccv4rNBGhiqJFX7g+2e2b0Kv1
         zLwz3rd4rJrkZahrDGLmEVIjMhyuUiToaEdEyImKZKKbx/s4LBxhd3bAqLSaLrzDi/
         2F5qd9ZvkPnpOdU8axbzYiRs2teZxYuX6u8weONfExEHW6kBPibE09935D49T21hHE
         z+gg0TP2cYX4w==
Date:   Thu, 23 Jun 2022 18:32:24 +0100
From:   Will Deacon <will@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Message-ID: <20220623173224.GB16966@willie-the-truck>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617210717.27126-1-madvenka@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> I have synced this patch series to v5.19-rc2.
> I have also removed the following patch.
> 
> 	[PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
> 
> as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
> yet. This patch will be added in the future once Objtool is enhanced to
> provide stack validation in some form.

Given that it's not at all obvious that we're going to end up using objtool
for arm64, does this patch series gain us anything in isolation?

Will
