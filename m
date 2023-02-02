Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A268E688747
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBBTC3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 14:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBBTC2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 14:02:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B48135244;
        Thu,  2 Feb 2023 11:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vonOtX4sHm5ySoollrrfaJlJdeuhvAtW4yhIzUNYhfs=; b=2ybRYd+M2k3pb8DfZm/IfwHhme
        oIE+a+KMPLzwq503uM0vBk+iaUmOs+f4c80MDQfyCgSQkDxhGuhF3xJtKwehRtnt5pMrZFmbbfBl2
        xkWSJr2IPa3DjntOHYTETpmbnNU/3j8aTJ2KLWha3W7U7WElG7L6A0c+4EVITGpMYnVy4APPh86DT
        eD6G5X4rKErlIkJFHFbJPK5trXjJ4iUvr4Au2fD3jnb/at9LlXCy/rbtgTOiB6hpm+1L5Im24T2o9
        BFHtlMzw+LA1YnPJyggrJmLXA+hdIHW/YEdeBtFwmnOsUyTBw4tHY+etCLrVhrJOzBA9QYSUac91Y
        PhKD6rLg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNeqp-00H1gw-KD; Thu, 02 Feb 2023 19:02:27 +0000
Date:   Thu, 2 Feb 2023 11:02:27 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] module.h: Document klp_modinfo struct members
Message-ID: <Y9wIw3f8IBOs4Ad6@bombadil.infradead.org>
References: <20230202182950.10471-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202182950.10471-1-mpdesouza@suse.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 02, 2023 at 03:29:50PM -0300, Marcos Paulo de Souza wrote:
> The struct members description can be found on
> Documentation/livepatch/module-elf-format.rst, but for a developer it's
> easier to search for such information looking at the struct definition.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Why not just embrace kdoc and then refer to it in the rst files?

  Luis
