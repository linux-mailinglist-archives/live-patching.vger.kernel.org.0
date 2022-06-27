Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3629755DD5F
	for <lists+live-patching@lfdr.de>; Tue, 28 Jun 2022 15:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiF0NCS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 09:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbiF0NB6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 09:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C2B12091;
        Mon, 27 Jun 2022 06:00:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99DCEB8166A;
        Mon, 27 Jun 2022 13:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFCBC341C7;
        Mon, 27 Jun 2022 13:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656334855;
        bh=DOQ5mwSpRmG7SdZF6XPq4GgQR+HBslD0lVkCHtkvk1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg3hiKDaCJUnAkCyUFjM7OEYotxMAxcrcQkoI1p1PTzJw9fgHDnJVKwUWKdnN7hyY
         o2vhmIl+XOCLlSXokF8cnAmRENBIAX8ErGTSDb5KzC3rPjuBXfFgjEqQnzLo/YETQy
         8uSBZi5Gn9XBc7GzfdrqLbsGOmlKGxmj0B49vI1RE9vMIDiwsQ8mbKraM/PDcYrbPI
         IaeM6mPPHtk/wmD5J7FWFufpzyuL/x9cF8UvVvzgU9OOEPe+mkQA7itUHEMIG8qYZP
         VPRlLd9brA9gXfUv8MDEpwJx5VAhadJPuQEzqX+bd4uHgGrFUbLbTl0Da710ZAW2MM
         GK7xhl7XAoKvQ==
From:   Will Deacon <will@kernel.org>
To:     sjitindarsingh@gmail.com, catalin.marinas@arm.com,
        madvenka@linux.microsoft.com, ardb@kernel.org,
        mark.rutland@arm.com, jamorris@linux.microsoft.com,
        jpoimboe@redhat.com, nobuta.keiya@fujitsu.com,
        live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, broonie@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v15 0/6] arm64: Reorganize the unwinder and implement stack trace reliability checks
Date:   Mon, 27 Jun 2022 14:00:43 +0100
Message-Id: <165632350271.638103.10773612881829908260.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220617180219.20352-1-madvenka@linux.microsoft.com>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24> <20220617180219.20352-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 17 Jun 2022 13:02:13 -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> I have synced this patch series to v5.19-rc2.
> I have also removed the following patch.
> 
> 	[PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
> 
> [...]

Applied first two patches to arm64 (for-next/stacktrace), thanks!

[1/6] arm64: Split unwind_init()
      https://git.kernel.org/arm64/c/a019d8a2cc82
[2/6] arm64: Copy the task argument to unwind_state
      https://git.kernel.org/arm64/c/82a592c13b0a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
