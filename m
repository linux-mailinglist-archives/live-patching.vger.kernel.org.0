Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB1A4A6A4E
	for <lists+live-patching@lfdr.de>; Wed,  2 Feb 2022 03:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244438AbiBBCro (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Feb 2022 21:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245011AbiBBCqH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Feb 2022 21:46:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21020C061749;
        Tue,  1 Feb 2022 18:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RDlZ57/xrx+iI2XcJbAwCQ+4gwxhicAmNoFMttMkXlo=; b=lgaO/nlV2c0KGjFO0z2be8I6Rt
        FmOvB3JRc/mJr4zCUYcXwQbZlA9jtVuUzCAtlY0IOvEU098yP3f+/GnhlHzr5ihRfc5WH8pkOnVc2
        7spAFs7clY5FJta2fkT6zbPSOCf/IYZqSEJbsMb6xqsLX6DoQuy5x8hToH1PQsLx2o9GEq0dHyCaN
        yMQcM3yvQOdtH6EPHq8zGGkqjdwYNyHYu6xuG3jEMU+CnUTgIdJT7pQSkPRgfeTb/nc0mep50jfoo
        SkBFrzQu6JRTT88yxmW6oGiixyHsfN6D2X4wSYsLZaU5E/OAxUlxR+nRNcaHjHMn6liYGd413tcKQ
        nBC6es3Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF5d9-00E1AJ-ON; Wed, 02 Feb 2022 02:44:23 +0000
Date:   Tue, 1 Feb 2022 18:44:23 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <YfnwB0GkXln4KaGk@bombadil.infradead.org>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Jan 30, 2022 at 09:32:01PM +0000, Aaron Tomlin wrote:
> Hi Luis,
> 
> As per your suggestion [1], this is an attempt to refactor and split
> optional code out of core module support code into separate components.
> This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
> modules-5.17-rc1. Please let me know your thoughts.

Nice, can you get this tested with 0day? You can ask for your tree to
be tested, see:

https://01.org/lkp/documentation/0-day-test-service

See the question, "Which git tree and which mailing list will be tested?
How can I opt-in or opt-out from it?"

  LUis
