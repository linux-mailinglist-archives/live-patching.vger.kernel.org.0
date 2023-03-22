Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ABB6C5A44
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 00:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCVXYs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Mar 2023 19:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCVXYr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Mar 2023 19:24:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E581BEC;
        Wed, 22 Mar 2023 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=z950tHfh6EL30Ry68ryUuE9SKuNl3wJnJXXGFZcnt9Q=; b=UFtsNZLqrpJZnIPJsNmouu7sPP
        BHHKxTqGFj2St8yKQFa9kHJDTZN+YbsXupvmBWsR4HFCDADBO4/6O8hi8MtnhIpSscbw53dGBsX15
        iPGRkwMr1f8UOY8di2PEqvcW2M+HsLcd8TfLjtRZ8etVPLRdYjd7/i+9WAKfUEmvqwdkS/no4BEzH
        f3FMNvfwfTMvIgOyNqxO6nLzZ4TTG1G9kVE1zsw7ac7V3nVry62uI9xZ4sV+eVmjeb3ufzSx344sl
        aRjMjSY1UsMjcIg/vV+fihRMFAWSNn92m2ekPWsnUZZNh6VqCO7F5h3Ir/9QbvuMHfjAqnmhSPKf1
        wINWkjAw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pf7ot-0007fT-26;
        Wed, 22 Mar 2023 23:24:39 +0000
From:   Luis Chamberlain <mcgrof@bombadil.infradead.org>
To:     jason.wessel@windriver.com, joe.lawrence@redhat.com,
        daniel.thompson@linaro.org, jikos@kernel.org,
        linux-modules@vger.kernel.org, llvm@lists.linux.dev,
        nathan@kernel.org, trix@redhat.com, chris@chrisdown.name,
        linux-kernel@vger.kernel.org, mbenes@suse.cz, terrelln@fb.com,
        kgdb-bugreport@lists.sourceforge.net,
        live-patching@vger.kernel.org, fmdefrancesco@gmail.com,
        dianders@chromium.org, pmladek@suse.com, jpoimboe@kernel.org,
        ndesaulniers@google.com, bpf@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>, ira.weiny@intel.com,
        dmitry.torokhov@gmail.com, swboyd@chromium.org,
        piotrgorski@cachyos.org
Subject: Re: [PATCH] module/decompress: Never use kunmap() for local un-mappings
Date:   Wed, 22 Mar 2023 16:24:33 -0700
Message-Id: <167952705567.2263470.18228933182686895553.b4-ty@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230315125256.22772-1-fmdefrancesco@gmail.com>
References: <20230315125256.22772-1-fmdefrancesco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

On Wed, 15 Mar 2023 13:52:56 +0100, Fabio M. De Francesco wrote:
> Use kunmap_local() to unmap pages locally mapped with kmap_local_page().
> 
> kunmap_local() must be called on the kernel virtual address returned by
> kmap_local_page(), differently from how we use kunmap() which instead
> expects the mapped page as its argument.
> 
> In module_zstd_decompress() we currently map with kmap_local_page() and
> unmap with kunmap(). This breaks the code and so it should be fixed.
> 
> [...]

Applied, thanks!

[1/1] module/decompress: Never use kunmap() for local un-mappings
      commit: 3c17655ab13704582fe25e8ea3200a9b2f8bf20a

  Luis
